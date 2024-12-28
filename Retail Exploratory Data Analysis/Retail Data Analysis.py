#!/usr/bin/env python
# coding: utf-8

# # Exploratory Data Analysis - Retail

# ##### GRIP@ The Sparks Foundation

# LinkedIn - https://www.linkedin.com/in/-mohamad-ehthesham/overlay/contact-info/

# GitHub - https://github.com/MohamadFaiz0102

# ## by Mohamad Ehthesham S

# In[50]:


import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
import seaborn as sns

get_ipython().run_line_magic('matplotlib', 'inline')


# In[51]:


data=pd.read_csv('SampleSuperstore.csv')


# Dataset can be found here https://drive.google.com/file/d/1lV7is1B566UQPYzzY8R2ZmOritTW299S/view

# In[52]:


data.head()


# In[53]:


data.info()


# In[54]:


data.head(3)


# In[55]:


data.describe()


# In[56]:


data.isnull().sum()


# In[57]:


data['Ship Mode'].nunique()


# ### Droping the non-essential columns

# In[58]:


data.drop(['Country','Postal Code'],inplace=True,axis=1)


# In[59]:


data.head(2)


# ### Checking for duplicates and deleting

# In[60]:


data.duplicated().sum()


# In[61]:


data.drop_duplicates(inplace=True)
data.duplicated().sum()


# ###  Max sales and Max profit

# In[62]:


print('Maximun Sales ',data['Sales'].max())
print('Maximun PRofit ',data['Profit'].max())


# ### Total sales made and total profit earned

# In[63]:


# total sales made and total profit earned
print('total sales made ',round(data['Sales'].sum(),2))
print('total profit earned ',round(data['Profit'].sum(),2))


# In[64]:


data.corr()


#  So we can say that.
# 
#     1. Sales and Quantity has Positive correlation
#     2. Sales and Discount has Negative correlation but somewhat weak
#     3. Sales and Profit has Positive correlation but somewhat strong
# 
#     4. Quantity and Discount we can say has No correlation
#     5. Quantity and Profit has Positive correlation but somewhat weak
# 
#     6. Discount and Profit has Negative correlation
#     7. Profit and Discount we can say has No correlation
# 

# In[65]:


plt.figure(figsize=(10,6))
sns.heatmap(data.corr(),annot=True)
plt.show()


# ### Ship Mode

# In[66]:


data['Ship Mode'].value_counts()


# In[67]:


sns.pairplot(data,hue='Ship Mode')


# In[68]:


sns.countplot(x=data['Ship Mode'])
plt.figure(figsize=[10,10]);


# So we can say.
# 
#     1. The most preferrd ship mode is Standard class
#     2. The least prefered ship mode is same day

# In[69]:


# total sales and profit per ship mode
sm=data.groupby('Ship Mode')[['Profit','Sales']].sum()
sm


# In[70]:


sm.plot(kind='bar',figsize=[10,6])
plt.title('Profit vs Sales')
plt.xticks(rotation=360);


# So we can say.
# 
#     1. So Standard class has the most Profit and Sales
#     2. Same day has lowest sales and profit

# In[71]:


data.head(2)


# ### Category

# In[72]:


cate=data['Category'].value_counts()
cate


# In[73]:


cate.plot(kind='pie',figsize=(10,6),autopct='%1.1f%%',shadow=True,startangle=180,
        explode=[0,0.1,0.1],labels=None, pctdistance=1.12,colors=['lightgreen','purple','lightblue'])

plt.legend(labels=cate.index,loc='lower left')
plt.tight_layout()
# so office supplies has the maximum sales


# So we can say.
# 
#     1. Office supplies has maximum buyers
#     2. Technology products has least buyers

# In[74]:


cps=data.groupby('Category')[['Sales','Profit']].sum()
cps
#So Technology product category has the maximum profit and sales


# In[75]:


cps.plot(kind='bar',figsize=(8,6))
plt.xticks(rotation=360)
plt.tight_layout()
plt.title('Category wise Profit and Sales')
plt.ylabel('Total Sales and Profit');


# So we can say.
# 
#     1. Technology Category products have maximum Sales and profits
#     2. Office supplies Category products have Minimum Sales
#     3. Furniture Category products has least Profit

# ### Sub-Category

# In[76]:


data.groupby('Sub-Category')[['Profit']].sum().sort_values(by=['Profit'],ascending=False)


# In[77]:


data.groupby('Sub-Category')[['Sales']].sum().sort_values(by=['Sales'],ascending=False)


#     so copiers, phones,accessories are the sub-cate products that have maximum profits
#     but Phones,Chairs, Storage are the sub-cate products that have maximum Sales

# In[78]:


# profit
scp=data.groupby('Sub-Category')[['Profit']].sum()
scp.sort_values(by=['Profit'],ascending=False).plot(kind='bar',figsize=(10,6),color='teal')
plt.xticks(rotation=50,ha='right');
plt.ylabel('profit')


scs=data.groupby('Sub-Category')[['Sales']].sum()
scs.sort_values(by=['Sales'],ascending=False).plot(kind='bar',figsize=(10,6),color='darkseagreen')
plt.xticks(rotation=50,ha='right');
plt.ylabel('Sales')


# In[79]:


sc=data['Sub-Category'].value_counts()
sc


# In[80]:


explode=[0,0,0,0,0,0,0,0,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1]
sc.plot(kind='pie',figsize=(10,6),startangle=180,autopct='%1.1f%%',wedgeprops={'linewidth':0.5,'edgecolor':'black'},pctdistance=1.11,labels=None,explode=explode)
plt.title('Sub-Category')
plt.tight_layout()
plt.legend(labels=sc.index)
plt.axis('equal');


#     Therefore Major distribution in business are from Binders,papers,Furnishings
#     Therefore Minor distribution in business are from Copiers

# ### Category-SubCategory 

# In[81]:


# sales per sub-category
css=data.groupby(['Category','Sub-Category'])['Sales'].sum()  #groupby with multiple columns
csp=data.groupby(['Category','Sub-Category'])['Profit'].sum()  #groupby with multiple columns
css


# ###  Sales

# In[82]:


# Sales
fig=plt.figure()

#furniture
a1=fig.add_subplot(2,2,1)
css['Furniture'].sort_values(ascending=False).plot(kind='barh',figsize=(15,15),ax=a1,color='gray')

# Office Supplies
a2=fig.add_subplot(2,2,2)
css['Office Supplies'].sort_values(ascending=False).plot(kind='barh',figsize=(15,15),ax=a2,color='gray')

# Technology
a3=fig.add_subplot(2,2,3)
css['Technology'].sort_values(ascending=False).plot(kind='barh',figsize=(15,15),ax=a3,color='gray')


# All 3
a4=fig.add_subplot(2,2,4)
css.sort_values(ascending=False).plot(kind='barh',ax=a4,figsize=(15,15),color='gray')

a1.set_title('Furniture')
a2.set_title('Office Supplies')
a3.set_title('Technology')


plt.tight_layout()


# So we observe that:
# 
#     MAximum Sales are in Phones(Technology),Chairs(Furnitures) and Storage(Office Supplies)
#     Minimum Sales are in Fasteners, Labels and Envelops (office supplies)

# ### Profit 

# In[83]:


# profit
fig=plt.figure()
a1=fig.add_subplot(2,2,1)
csp['Furniture'].sort_values(ascending=False).plot(kind='barh',figsize=(15,15),ax=a1,color='olive')

a2=fig.add_subplot(2,2,2)
csp['Office Supplies'].sort_values(ascending=False).plot(kind='barh',figsize=(15,15),ax=a2,color='olive')

a3=fig.add_subplot(2,2,3)
csp['Technology'].sort_values(ascending=False).plot(kind='barh',figsize=(15,15),ax=a3,color='olive')

a4=fig.add_subplot(2,2,4)
csp.sort_values(ascending=False).plot(kind='barh',ax=a4,figsize=(15,15))

csp.sort_values(ascending=False).plot(kind='barh',ax=a4,figsize=(20,20),color='olive')

a1.set_title('Furniture')
a2.set_title('Office Supplies')
a3.set_title('Technology')

a4.grid(True,linewidth=0.5)
plt.tight_layout()


# So we observe that:
# 
#     MAximum Profit are in Copiers,Phones and Accesories(TEchnology)
#     Also most loss are in Tables and bookcases(Furniture) and Supplies(Office Supplies)

# In[84]:


data.head(2)


# ### State

# In[85]:


# highest state with most buyers and sales
data['State'].value_counts().plot(kind='bar',figsize=(20,10))
plt.grid(True,linewidth=0.2,color='b')
plt.xticks(rotation=75);

# so california has the maximum sales and buyers and wymoning has lowest sales and buyers


#     So highest state with most buyers and sales are from "California","New York","Texas"
#     So california has the maximum sales and buyers and 
#     "West Virginia","Wyoming" has lowest sales and buyers
# 

# In[86]:


# Profit and Sales per state
st_s=data.groupby(['State']).Sales.sum().sort_values(ascending=False)
st_p=data.groupby(['State']).Profit.sum().sort_values(ascending=False)


# In[87]:


st_s.sort_values(ascending=False).plot(kind='bar',figsize=(15,8),color='red')
st_p.sort_values(ascending=False).plot(kind='bar',figsize=(15,8),color='g')

plt.legend()
plt.xticks(rotation=50,fontsize=10,ha='right');

# so california has the maximum sales and profit and wyoming has lowest sales and profit


#     So Maximum Sales and PRofit are from "California","New York","Washington"
#     Most losess are from "Pennsylvania","Ohio","Texas"

# ### Segemnt portion of sales
# 

# In[88]:


# segemnt portion of sales
ss=data['Segment'].value_counts()
ss.plot(kind='pie',autopct='%1.1f%%',figsize=(10,6),startangle=180,
                                    wedgeprops={'linewidth':0.5,'edgecolor':'black'},labels=None,pctdistance=1.15)

plt.title('Each Segment Share')
plt.axis('equal')
plt.legend(labels=ss.index);


#     So Consumer Segment has MAximum Business Share
#     And Home office has least Business Share

# ### Region 

# In[89]:


# region
rps=data.groupby('Region')[['Sales','Profit']].sum().sort_values(by=['Sales','Profit'],ascending=False)
rps


# In[90]:


rps.plot(kind='bar',figsize=(10,6))

plt.title('Sales and Profit based on Regions')
plt.ylabel('Sales and PRofit',ha='right')
plt.xticks(rotation=360);


#     So as we can see Western Region has the maximum sales and profit 
#     and southern region has Lowest sales and profit

# ### Relation between profit and discount
#  

# In[91]:


# Relation between profit and discount
data['Discount'].corr(data['Profit'])   # or data['Profit'].corr(data['Discount'])


#     So discount and profit has Negative correlation.

# In[92]:


sns.lineplot(x='Discount',y='Profit',data=data)
plt.figure(figsize=(10,10));

# so we can say that Discount and PRofit has negative effect.


#     So we can say that Discount and PRofit has negative effect.

# In[93]:


sns.pairplot(data);


# So we can Observe that
# 1. so as Discount increases profit decreases
# 2. As discount increases sales decreases
# 3. As Sales increase profit increase

# In[94]:


sns.relplot(x='Discount',y='Sales',hue='Profit',data=data)


# ### Observations

#     Maximun Sales  22638.48
#     Maximun PRofit  8399.976
# 
#     total sales made  2294599.38
#     total profit earned  286097.56
# 
#     1. Sales and Quantity has Positive correlation
#        Sales and Discount has Negative correlation but somewhat weak
#        Sales and Profit has Positive correlation but somewhat strong
# 
#     2. Quantity and Discount we can say has No correlation
#        Quantity and Profit has Positive correlation but somewhat weak
# 
#     3. Discount and Profit has Negative correlation
#        Profit and Discount we can say has No correlation
# 
#     4. The most preferrd ship mode is Standard class
#        The least prefered ship mode is same day
# 
#     5. So Standard class has the most Profit and Sales
#        Same day has lowest sales and profit
# 
#     6. Office supplies has maximum buyers
#        Technology products has least buyers
# 
#     7. Technology Category products have maximum Sales and profits
#        Office supplies Category products have Minimum Sales
#        Furniture Category products has least Profits
# 
#     8. so copiers, phones,accessories are the sub-cate products that have maximum profits
#        but Phones,Chairs, Storage are the sub-cate products that have maximum Sales
#        
#        Therefore Major distribution in business are from Binders,papers,Furnishings
#        Therefore Minor distribution in business are from Copiers
# 
#     9. MAximum Sales are in Phones(Technology),Chairs(Furnitures) and Storage(Office Supplies)
#        Minimum Sales are in Fasteners, Labels and Envelops (office supplies)
# 
#     10.MAximum Profit are in Copiers,Phones and Accesories(TEchnology)
#        Also most loss are in Tables and bookcases(Furniture) and Supplies(Office Supplies)
# 
#     11. So highest state with most buyers and sales are from "California","New York","Texas"
#         So california has the maximum sales and buyers and 
#         "West Virginia","Wyoming" has lowest sales and buyers
# 
#     12. So Maximum Sales and PRofit are from "California","New York","Washington"
#         losess are from "Pennsylvania","Ohio","Texas"
# 
#     13. So Consumer Segment has MAximum Business Share
#         And Home office has least Business Share
# 
#     14.  So as we can see Western Region has the maximum sales and profit 
#          and southern region has Lowest sales and profit
# 
#     15. So we can say that Discount and PRofit has negative effect.
#          so as Discount increases profit decreases
#          As discount increases sales decreases
#          As Sales increase profit increase

# In[ ]:




