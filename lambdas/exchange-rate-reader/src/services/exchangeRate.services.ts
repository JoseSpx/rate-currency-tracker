import { DynamoDBDocumentClient, PutCommand } from "@aws-sdk/lib-dynamodb";
import { getConnection } from "../db/dynamoConnection.js";
import { ExchangeRateData } from "../interfaces/exchangeRateData.interface.js";
import { randomUUID } from "crypto";
import { getTableName } from "../utils/helpers.js";

export const saveExchangeRate = async (data: ExchangeRateData) => {
  const client = DynamoDBDocumentClient.from(getConnection());

  // Prepare the item with required fields
  const item: ExchangeRateData = {
    id: data.id || randomUUID(),
    timestamp: data.timestamp || Math.floor(Date.now() / 1000), // Unix timestamp
    exchangeRate: data.exchangeRate,
    buyPrice: data.buyPrice,
    sellPrice: data.sellPrice
  };

  const tableName = getTableName(process.env.DYNAMODB_TABLE_NAME || "exchange-rates");
  console.log(`Using DynamoDB table: ${tableName}`);
  const command = new PutCommand({
    TableName: tableName,
    Item: item
  });

  try {
    await client.send(command);
    console.log("Successfully saved exchange rate data:", item);
    return item;
  } catch (error) {
    console.error("Error saving to DynamoDB:", error);
    throw error;
  }
}