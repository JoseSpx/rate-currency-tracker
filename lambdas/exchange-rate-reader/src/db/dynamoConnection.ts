import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { fromIni } from "@aws-sdk/credential-providers";

export const getConnection = () => {
  if (process.env.APP_ENV === "local") {
    return new DynamoDBClient({
     region: process.env.APP_AWS_REGION || "us-east-2",
     credentials: fromIni()
   });
  } else {
    return new DynamoDBClient({});
  }
}