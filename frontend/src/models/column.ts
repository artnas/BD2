export interface Column {
    name: string,
    type: string,
    isPrimaryKey: boolean,
    foreignKeyTableName: string
}