import { Column } from './column';

export interface RowDialogData {
    tableName: string,
    columns: Column[];
    data: any[],
    isAddMode: boolean
}