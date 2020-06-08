import { Component, OnInit, ViewChild } from '@angular/core';
import { Table } from 'src/models/table';
import { HttpClient } from '@angular/common/http';
import { SelectionModel } from '@angular/cdk/collections';
import { MatTableDataSource } from '@angular/material/table';
import { MatPaginator } from '@angular/material/paginator';

@Component({
  selector: 'app-table',
  templateUrl: './table.component.html',
  styleUrls: ['./table.component.css']
})
export class TableComponent implements OnInit {

  constructor(private httpClient: HttpClient) { }

  public model: Table;
  public dataSource: MatTableDataSource<any>;

  public displayedColumns: string[];
  public selection = new SelectionModel<any>(true, []);

  @ViewChild(MatPaginator, { static: true }) paginator: MatPaginator;

  ngOnInit(): void {
    this.getTableData();
  }

  private getTableData() {
    this.httpClient.get('/assets/mocks/table-data.json').subscribe((model: Table) => {
      this.model = model;
      this.displayedColumns = this.getColumnNames(model);
      this.dataSource = new MatTableDataSource<any>(model.data);
      this.dataSource.paginator = this.paginator;
    })
  }

  private getColumnNames(model: Table): string[] {
    const columnNames = ['select'];

    for (const column of model.columns) {
      columnNames.push(column.name);
    }

    return columnNames;
  }

  public getSelectedRowsCount(): number {
    return this.selection.selected.length;
  }

  /** Whether the number of selected elements matches the total number of rows. */
  isAllSelected() {
    const numSelected = this.selection.selected.length;
    const numRows = this.model.data.length;
    return numSelected === numRows;
  }

  /** Selects all rows if they are not all selected; otherwise clear selection. */
  masterToggle() {
    this.isAllSelected() ?
      this.selection.clear() :
      this.model.data.forEach(row => this.selection.select(row));
  }

  /** The label for the checkbox on the passed row */
  checkboxLabel(row?: any): string {
    if (!row) {
      return `${this.isAllSelected() ? 'select' : 'deselect'} all`;
    }
    return `${this.selection.isSelected(row) ? 'deselect' : 'select'} row ${row.position + 1}`;
  }

}
