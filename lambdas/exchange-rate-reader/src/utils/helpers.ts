export const getTableName = (tableName: string) => {
  return `${tableName}-${process.env.ENV_PREFIX}`;
}