import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Arithmetics unoptimized

gasCosts = pd.read_csv('./arithmetics/gasCostsArithmetics.csv')

sns.barplot(data=gasCosts, x="function", y="gasUsage", hue="Implementation", palette="pastel")

plt.title("Arithmetics")
plt.ylabel("gas units used")
plt.xlabel("type of function")

plt.ylim([21000, 23000])

plt.show()


# Arithmetics optimized

gasCosts = pd.read_csv('./arithmetics/gasCostsArithmeticsOpt.csv')

sns.barplot(data=gasCosts, x="function", y="gasUsage", hue="Implementation", palette="pastel")

plt.title("Arithmetics optimized (1500 runs)")
plt.ylabel("gas units used")
plt.xlabel("type of function")

plt.ylim([21000, 23000])

plt.show()


# Owner Standard unoptimized

gasCosts = pd.read_csv('./ownerStandard/gasCostsOwnerStandard.csv')

sns.barplot(data=gasCosts, x="function", y="gasUsage", hue="Implementation", palette="pastel")

plt.title("OnlyOwner modifier")
plt.ylabel("gas units used")
plt.xlabel("type of function")

plt.ylim([22000, 24000])

plt.show()


# Owner Standard optimized

gasCosts = pd.read_csv('./ownerStandard/gasCostsOwnerStandardOpt.csv')

sns.barplot(data=gasCosts, x="function", y="gasUsage", hue="Implementation", palette="pastel")

plt.title("OnlyOwner modifier optimized (1500 runs)")
plt.ylabel("gas units used")
plt.xlabel("type of function")

plt.ylim([22000, 24000])

plt.show()


# Transfer

gasCosts = pd.read_csv('./transfer/gasCostsTransfer.csv')

sns.barplot(data=gasCosts, x="function", y="gasUsage", hue="Implementation", palette="pastel")

plt.title("Transfer Ether")
plt.ylabel("gas units used")
plt.xlabel("type of function")

plt.ylim([30000, 32000])

plt.show()



# Transfer optimized

gasCosts = pd.read_csv('./transfer/gasCostsTransferOpt.csv')

sns.barplot(data=gasCosts, x="function", y="gasUsage", hue="Implementation", palette="pastel")

plt.title("Transfer Ether optimized (1500 runs)")
plt.ylabel("gas units used")
plt.xlabel("type of function")

plt.ylim([30000, 32000])

plt.show()



# Transfer ERC20

gasCosts = pd.read_csv('./transferToken/gasCostsTokenTransfer.csv')

sns.barplot(data=gasCosts, x="function", y="gasUsage", hue="Implementation", palette="pastel")

plt.title("ERC-20 Token Transfer")
plt.ylabel("gas units used")
plt.xlabel("type of function")

plt.ylim([28000, 55000])

plt.show()


# Transfer ERC20 optimized

gasCosts = pd.read_csv('./transferToken/gasCostsTokenTransferOpt.csv')

sns.barplot(data=gasCosts, x="function", y="gasUsage", hue="Implementation", palette="pastel")

plt.title("ERC-20 Token Transfer optimized (1500 runs)")
plt.ylabel("gas units used")
plt.xlabel("type of function")

plt.ylim([28000, 55000])

plt.show()



# Crowdfunding

gasCosts = pd.read_csv('./crowdfunding/gasCostsCrowdfunding.csv')

sns.barplot(data=gasCosts, x="function", y="gasUsage", hue="Implementation", palette="pastel")

plt.title("Crowdfunding")
plt.ylabel("gas units used")
plt.xlabel("type of function")

plt.ylim([30000, 55000])

plt.show()



# Crowdfunding optimized

gasCosts = pd.read_csv('./crowdfunding/gasCostsCrowdfundingOpt.csv')

sns.barplot(data=gasCosts, x="function", y="gasUsage", hue="Implementation", palette="pastel")

plt.title("Crowdfunding optimized (1500 runs)")
plt.ylabel("gas units used")
plt.xlabel("type of function")

plt.ylim([30000, 55000])

plt.show()