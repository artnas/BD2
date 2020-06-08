import { Column } from './column';

export interface Table {
    columns: Column[],
    data: any[]
}