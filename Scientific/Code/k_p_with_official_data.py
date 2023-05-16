# -*- coding: utf-8 -*-
"""K-P with official data.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1TtrA-X-_UEWy-gyxJf98t1oOqg2gFR8D
"""

pip uninstall kmodes && pip install kmodes

"""# EDA DATA

"""

# Commented out IPython magic to ensure Python compatibility.
#import thư viện
get_ipython().run_line_magic('matplotlib', 'inline')
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
# Import module for data visualization
from plotnine import *
import plotnine
# !pip install kmodes
from kmodes.kmodes import KModes
import matplotlib.pyplot as plt
# %matplotlib inline
# Import module for k-protoype cluster
from kmodes.kprototypes import KPrototypes
# Ignore warnings
import warnings
warnings.filterwarnings('ignore', category = FutureWarning)
# Format scientific notation from Pandas
pd.set_option('display.float_format', lambda x: '%.3f' % x)
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import silhouette_samples, silhouette_score
from matplotlib.ticker import FixedLocator, FixedFormatter
import matplotlib.cm as cm
from sklearn.cluster import KMeans

# Colab connect drive
from google.colab import drive
drive.mount('/content/Dataset')

## Read data (đọc dữ liệu)
Rtl_data = pd.read_csv('/content/Dataset/Shareddrives/NGHIÊN CỨU KHOA HỌC - DATA /RFM MỞ RỘNG/Dataset/Training dataset.csv')

#Check number of null data (check giá trị null)
Rtl_data.isnull().sum(axis=0)

#check duplicate data (check dữ liệu trùng lắp)
import ipywidgets
from ipywidgets import interact
def duplicate_values(df):
    print("Duplicate check...", sep='')
    duplicate_values = df.duplicated(subset=None, keep='first').sum()
    if duplicate_values > 0:
        df.drop_duplicates(keep='first', inplace=True)
        print(duplicate_values, " Duplicates were dropped!",'\n',
             '*'*100, 'red', sep='')
    else:
        print("There are no duplicates",'\n',
              '*'*100, 'red', sep='')    
duplicate_values(Rtl_data)

dataset = Rtl_data

#Bỏ đi những cột không cần thiết
dataset = Rtl_data.drop(['item_id', 'sku','payment_method', 'bi_st', 'ref_num', 'Name Prefix', 
                         'First Name', 'Middle Initial', 'Last Name', 'full_name','E Mail','SSN', 'Place Name','County', 'Zip','State',
                         'User Name', 'year', 'value', 'discount_amount', 'total', 'category', 'Customer Since','City', 'Discount_Percent','month'], axis=1)

#Xem các giá trị của cột trạng thái
dataset['status'].value_counts()

#Loại bỏ các giao dịch bị hủy, hoàn tiền
dataset= dataset.loc[(dataset['status'] != 'canceled') & (dataset['status'] != 'order_refunded') & (dataset['status'] != 'refund') ]
dataset['status'].value_counts()

#Xem số dòng, cột sau khi loại đơn hàng bị hủy, hoàn tiền
dataset.shape

#Kiểm tra xem có bao nhiêu khách hàng còn lại sau khi lọc đơn bị hủy, hoàn tiền
dataset.cust_id.nunique()

#Sau khi chỉ còn lại đơn hợp lệ thì mình bỏ đi cột Status
dataset = dataset.drop(['status'], axis=1)
dataset.head()

#Convert the string date field to datetime (chuyển kiểu dữ liệu của order_date thành datetime)
dataset['order_date'] = pd.to_datetime(dataset['order_date'])

#Add new column depicting total amount (thêm cột tính Total Amount vào)
dataset['TotalAmount'] = dataset['qty_ordered'] * dataset['price']

#Xem thông tin bộ dữ liệu sau khi thêm cột Total Amount vào
dataset.info()
dataset.head()

#Xem số lượng giao dịch đến từ từng vùng
dataset['Region'].value_counts()

#XÂY DỰNG MÔ HÌNH RFM CHO DATASET
#Recency = Latest Date - Last Inovice Data, Frequency = count of invoice no. of transaction(s), Monetary = Sum of Total 
#Amount for each customer
import datetime as dt
dataset['order_date'] = pd.to_datetime(dataset['order_date'])

# lấy ngày gần đây nhất + 1 ( để khi lấy ngày hiện tại trừ ra sẽ ko âm), ngày hiện tại sẽ mang giá trị 1, trừ đi những ngày khác sẽ ra giá trị F
Latest_Date = max(dataset['order_date']) + dt.timedelta(days=1)

#Create RFM Modelling scores for each customer (Tạo các biến R, F, M cho từng khách hàng)
RFMScores = dataset.groupby('cust_id').agg(
    {'order_date': lambda x: (Latest_Date - x.max()).days, 
     'order_id': 'count', 
     'TotalAmount': 'sum',
     'Gender': 'max',
     'Region':'max',
     'age':'max'
    })

#Convert order_date into type int (Chuyển order_date thành kiểu int)
RFMScores['order_date'] = RFMScores['order_date'].astype(int)

#Rename column names to Recency, Frequency and Monetary (đổi tên các cột thành Recency, Frequency, Monetary)
RFMScores.rename(columns={'order_date': 'Recency', 
                         'order_id': 'Frequency', 
                         'TotalAmount': 'Monetary',
                          'age': 'Age'}, inplace=True)

RFMScores.reset_index().head()

#Descriptive Statistics (Recency)
RFMScores.Recency.describe()
#Tứ phân vị của Recency

#Xem phân bổ dữ liệu của Recency
x = RFMScores['Recency']
ax = sns.distplot(x)

#Check oulier cho Recency
red_square = dict(markerfacecolor='r', marker='s')
fig5, ax5 = plt.subplots()
ax5.set_title('Horizontal Boxes')
ax5.boxplot(RFMScores['Recency'], vert=False, flierprops=red_square)
#Recency không có outlier

#Xem tứ phân vị của Frequency
RFMScores.Frequency.describe()

#Xem phân phối của Frequency
x = RFMScores['Frequency']
ax = sns.distplot(x)
#Bị lệch phải khá nhiều

#Check outlier cho Frequency
red_square = dict(markerfacecolor='r', marker='s')
fig6, ax6 = plt.subplots()
ax6.set_title('Horizontal Boxes')
ax6.boxplot(RFMScores['Frequency'], vert=False, flierprops=red_square)
#Frequency có outlier

"""# REMOVE OUTLIER vs NOMALIZE DATA

"""

#Lọc ra những giá trị Monetary = 0
RFMScores= RFMScores.loc[(RFMScores['Monetary'] != 0)]

#Kiểm tra số lượng khách hàng sau khi lọc
RFMScores.shape

#Bộ dữ liệu chỉ có các biến RFM, tách riêng 3 biến R, F,M để đi boxcox và scale
RFM = RFMScores
RFM = RFM.drop(['Age','Gender', 'Region'], axis=1)
RFM

#Viết hàm phân tích thử nên dùng log, căn bậc 2 hay boxcox
from scipy import stats
def analyze_skewness(x):
   fig, ax = plt.subplots(2,2, figsize=(5,5))
   sns.distplot(RFMScores[x], ax=ax[0,0])
   sns.distplot(np.log(RFMScores[x]), ax=ax[0,1])
   sns.distplot(np.sqrt(RFMScores[x]), ax=ax[1,0])
   sns.distplot(stats.boxcox(RFMScores[x])[0], ax=ax[1,1])
   plt.tight_layout()
   plt.show()

   print(RFMScores[x].skew().round(2))
   print(np.log(RFMScores[x]).skew().round(2))
   print(np.sqrt(RFMScores[x]).skew().round(2))
   print(pd.Series(stats.boxcox(RFMScores[x])[0]).skew().round(2))

analyze_skewness('Recency')

analyze_skewness('Frequency')

analyze_skewness('Monetary')

#Boxcox transformation
from scipy import stats
RFM['Recency'] = stats.boxcox(RFM['Recency'])[0]
RFM['Frequency'] = stats.boxcox(RFM['Frequency'])[0]
RFM['Monetary'] = stats.boxcox(RFM['Monetary'])[0]

#Hình dáng dữ liệu sau khi dùng boxcox
fig, ax = plt.subplots(1, 3,figsize= (12,4))
sns.distplot(RFM['Recency'], ax = ax[0])
sns.distplot(RFM['Frequency'], ax = ax[1])
sns.distplot(RFM['Monetary'], ax = ax[2])
plt.show()

# Tiến hành Scale dữ liệu => dạng array
from sklearn.preprocessing import StandardScaler
scaler = StandardScaler()
Scaled_Data = scaler.fit_transform(RFM) 
Scaled_Data

#Chuyển scaled data thành Dataframe
Scaled_Data = pd.DataFrame(Scaled_Data, index = RFM.index, columns = RFM.columns)
Scaled_Data

from sklearn.cluster import KMeans
   #Kmeans:
kmean = KMeans(n_clusters = 4,init = 'k-means++',max_iter = 1000)
cluster_labels_km_RFM =kmean.fit_predict(Scaled_Data)

RFMScores.to_csv('RFMScores.csv')

#Bộ dữ liệu chỉ có các biến Demo, sau này sẽ thêm các biến R,F,M sau khi scale vào để ra bộ cuối cùng
RFMD= RFMScores
RFMD = RFMD.drop(['Recency', 'Frequency', 'Monetary'], axis=1)
RFMD

#Thêm cột R, F, M vào cái RFMD
extracted_col = Scaled_Data["Recency"]
RFMD = RFMD.join(extracted_col)
extracted_col = Scaled_Data["Frequency"]
RFMD = RFMD.join(extracted_col)
extracted_col = Scaled_Data["Monetary"]
RFMD = RFMD.join(extracted_col)
RFMD
#RFMD là cái cuối cùng để tiến hành các bước tiếp theo

#lưu file về
 RFMD.to_csv('RFMD.csv')

"""# K - PROTOTYPE"""

RFMD_Final = pd.read_csv('/content/Dataset/Shareddrives/NGHIÊN CỨU KHOA HỌC - DATA /RFM MỞ RỘNG/1. Final_dataset/[Final] - RFMD_afterScaled.csv')

RFMD_Final_before = pd.read_csv('/content/Dataset/Shareddrives/NGHIÊN CỨU KHOA HỌC - DATA /RFM MỞ RỘNG/1. Final_dataset/[Final] - RFMD_beforeScaled.csv')

bins = [18,25,65,75]
labels=['Age 18-24','Age 25-65','Age 65+']
RFMD_Final_before['Age'] = pd.cut(RFMD_Final_before['Age'], bins=bins, labels=labels, include_lowest=True)

RFMD_Final_before.head(5)

RFMD_KPROTOTYPE = RFMD_Final

# chia khoảng cho cột age 
bins = [18,25,65,75]
labels=['Age 18-24','Age 25-65','Age 65+']
RFMD_KPROTOTYPE['Age'] = pd.cut(RFMD_KPROTOTYPE['Age'], bins=bins, labels=labels, include_lowest=True)

RFMD_KPROTOTYPE = RFMD_KPROTOTYPE.drop(['cust_id'], axis=1)

RFMD_KPROTOTYPE['Age'] = RFMD_KPROTOTYPE['Age'].astype(object)

# Get the position of categorical columns
catColumnsPos = [RFMD_KPROTOTYPE.columns.get_loc(col) for col in list(RFMD_KPROTOTYPE.select_dtypes('object').columns)]
print('Categorical columns           : {}'.format(list(RFMD_KPROTOTYPE.select_dtypes('object').columns)))
print('Categorical columns position  : {}'.format(catColumnsPos))

# Convert dataframe to matrix
dfMatrix = RFMD_KPROTOTYPE.to_numpy()
dfMatrix

# Choose optimal K using Elbow method
#vẽ elbow để chọn k
#buoc nay co the skip khi chạy lần 2 vi chi dung de ve elbow thoi
cost = []
for cluster in range(2, 12):
        kprototype = KPrototypes(n_jobs = -1, n_clusters = cluster, init = 'Huang', random_state = 0)
        kprototype.fit_predict(dfMatrix, categorical = catColumnsPos)
        cost.append(kprototype.cost_)
        print('Cluster initiation: {}'.format(cluster))

#vì mô hình chạy khá lâu nên lưu lại kết quả
cost= [102773.07213615411,
 82326.21792915829,
 71487.5571447669,
 62515.16589455648,
 57815.68968068354,
 53374.07229009956,
 50431.62090221602,
 47674.79783431964,
 45353.63370385708,
 43911.61190737834]

# Converting the results into a dataframe and plotting them
df_cost = pd.DataFrame({'Cluster':range(1, 11), 'cost':cost})

import seaborn as sns
cluster = list(range(2, 12))

# plot cost against number of clusters
ax = sns.lineplot(x=cluster, y=cost, marker="o")
ax.set_title('Elbow curve', fontsize=14)
ax.set_xlabel('Number of clusters', fontsize=11)
ax.set_ylabel('Huang cost', fontsize=11)

#phan cụm kprototype voi k =1
kproto = KPrototypes(n_clusters= 5 , verbose=2,max_iter=20)
clusters_k_group_kprototype_5= kproto.fit_predict(dfMatrix, categorical=catColumnsPos )

# dữ liệu này lưu về dùng để visualize , sorry vì đặt tên hơi khó hiểu
RFMD_Final_before['cluster5'] =clusters_k_group_kprototype_5

RFMD_Final_before.to_csv('RFMD_KPROTOTYPE_5Clusters.csv')

"""#Kmean"""

RFMD_KMeans_temp = RFMD_Final

from sklearn.preprocessing import LabelEncoder
gender_encoder = LabelEncoder()

gender_encoder.fit(RFMD_KMeans_temp['Gender'])
gender_values = gender_encoder.transform(RFMD_KMeans_temp['Gender'])

RFMD_KMeans_temp['Gender Label'] = gender_values

RFMD_KMeans_temp.head(20)

bins = [18,24,64,75]
labels=['Age 18-24','Age 25-64','Age 65+']
RFMD_KMeans_temp['Age'] = pd.cut(RFMD_KMeans_temp['Age'], bins=bins, labels=labels, include_lowest=True)
RFMD_KMeans_temp

RFMD_KMeans_temp = pd.get_dummies(RFMD_KMeans_temp, columns=['Age'])
RFMD_KMeans_temp.head(10)

region_encoder = LabelEncoder()
region_encoder.fit(RFMD_KMeans_temp['Region'])
region_values = region_encoder.transform(RFMD_KMeans_temp['Region'])
RFMD_KMeans_temp['Region Label'] = region_values
RFMD_KMeans_temp = pd.get_dummies(RFMD_KMeans_temp, columns=['Region Label'])

RFMD_KMeans_temp.head(5)

RFMD_KMeans_temp.rename(columns={'Gender Label_0': 'Gender F', 'Gender Label_1': 'Gender M',
                        'Age Range_Age 18-24': 'Age 18-24', 'Age Range_Age 25-64': 'Age 25-64', 'Age Range_Age 65+': 'Age 65+', 'Region Label_0':'Region Midwest', 'Region Label_1':'Region Northeast', 'Region Label_2':'Region South',	'Region Label_3':'Region West'}, inplace=True)
RFMD_KMeans_temp

RFMD_KMeans_temp = RFMD_KMeans_temp.drop(['Gender','Region'], axis = 'columns')

RFMD_KMeans_temp = RFMD_KMeans_temp.drop(['Unnamed: 0', 'cust_id', 'Age Range'], axis = 'columns')

import numpy as np
from collections import Counter, defaultdict
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon
import matplotlib.cm
import itertools

#Kmeans:
kmean = KMeans(n_clusters = 5,init = 'k-means++',max_iter = 10000)
cluster_labels_km =kmean.fit_predict(RFMD_KMeans_temp)

cluster_labels_km

RFMDKMEANS = RFMD_Final_before

RFMD_Final_before.to_csv('RFMDKMEANS.csv')

RFMDKMEANS["clusterid_kmeans"] = cluster_labels_km

RFMDKMEANS = RFMDKMEANS.drop(['clusterID_kp'], axis = 'columns')

RFMDKMEANS.to_csv('RFMDKMEANS.csv')

pd.set_option('display.max_rows', None)
pd.set_option('display.max_columns', None)
pd.set_option('display.width', None)
pd.set_option('display.max_colwidth', None)
RFMScores_6_nomarlize = RFMCOMPARE.drop(columns=["Age","Gender","Region"]).groupby('clusterid').describe()
RFMScores_6_nomarlize

"""# ARI (KPROTOTPYES, KMEANS )"""

from sklearn.metrics.cluster import adjusted_rand_score
adjusted_rand_score(clusters_k_group_kprototype_6, cluster_labels_km )

"""# Visualization 5 cụm"""

RFMScores_5 = RFMScores
RFMScores_5['Cluster'] = clusters_k_group_kprototype_5

from sklearn.preprocessing import LabelEncoder
gender_encoder = LabelEncoder()
df5group = RFMScores_5.copy()
gender_encoder.fit(df5group['Gender'])
gender_values = gender_encoder.transform(df5group['Gender'])
df5group['Gender'] = gender_values
gender_encoder.fit(df5group['Region'])
gender_values = gender_encoder.transform(df5group['Region'])
df5group['Region'] = gender_values
#Visualize K-Prototype clustering on the PCA projected Data
df5group['Cluster_id']= clusters_k_group_kprototype_5
print(df5group['Cluster_id'].value_counts())
sns.pairplot(df5group,hue='Cluster_id',palette='Dark2',diag_kind='kde')

plt.subplots(figsize = (15,5))
sns.countplot(x=RFMScores_5['Region'],order=RFMScores_5['Region'].value_counts().index,hue=df5group["Cluster_id"])
plt.show()

plt.subplots(figsize = (5,5))
sns.countplot(x=df5group['Gender'],order=df5group['Gender'].value_counts().index,hue=df5group['Cluster_id'])
plt.show()

df_5 = df5group.copy()
df_5['group_age'] = pd.cut(df_5['Age'],bins,labels=["18-24", "25-64","> 64"]) 
plt.subplots(figsize = (15,5))
sns.countplot(x=df_5['group_age'],order=df_5['group_age'].value_counts().index,hue=df5group["Cluster_id"])
plt.show()

#mấy cái này để mình nhìn full column
pd.set_option('display.max_rows', None)
pd.set_option('display.max_columns', None)
pd.set_option('display.width', None)
pd.set_option('display.max_colwidth', None)
RFMScores_5_nomarlize = RFMScores_5.drop(columns=["Age","Gender","Region"]).groupby('Cluster').describe()
RFMScores_5_nomarlize