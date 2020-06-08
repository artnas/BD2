import { Component, OnInit, ViewChild } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { SelectionModel } from '@angular/cdk/collections';
import { MatTableDataSource } from '@angular/material/table';
import { MatPaginator } from '@angular/material/paginator';
import { MatDialog } from '@angular/material/dialog';
import { RowAddEditViewComponent } from '../row-add-edit-view/row-add-edit-view.component';
import { ActivatedRoute, Router, NavigationEnd } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { Column } from 'src/models/column';

@Component({
  selector: 'app-table',
  templateUrl: './table.component.html',
  styleUrls: ['./table.component.css']
})
export class TableComponent implements OnInit {

  private enableMocking = true;

  constructor(private httpClient: HttpClient, public dialog: MatDialog, private route: ActivatedRoute, private toastr: ToastrService) { 
    route.params.subscribe((params) => {
      this.tableName = params.name;
      this.getTableData();
    });
  }

  public tableName: string;

  public columns: Column[];
  public dataSource: MatTableDataSource<any>;

  public displayedColumns: string[];
  public selection = new SelectionModel<any>(true, []);

  @ViewChild(MatPaginator, { static: true }) paginator: MatPaginator;

  ngOnInit(): void {
    this.enableMocking = document.location.port === '4200';
  }

  private getTableData() {
    const columnsMetadataUrl = `/assets/table-columns/${this.tableName}.json`;
    const tableDataUrl = this.getTableDataUrl();

    // get columns metadata
    this.httpClient.get(columnsMetadataUrl).subscribe((columns: Column[]) => {
      this.columns = columns
      this.displayedColumns = this.getColumnNames(columns);
      this.dataSource = null;

      // get data
      this.httpClient.get(tableDataUrl).subscribe((data: any[][]) => {
        this.processTableData(data);
      }, (error) => {
        this.toastr.show(error.message);
      });
    }, (error) => {
      this.toastr.show(error.message);
    });
  }

  private processTableData(data: any[][]) {
    this.dataSource = new MatTableDataSource<any>(data);
    this.dataSource.paginator = this.paginator;
  }

  private getTableDataUrl() {
    if (this.enableMocking) {
      return `/assets/table-data/${this.tableName}.json`;
    } else {
      return `/api/table/${this.tableName}`;
    }
  }

  private getColumnNames(columns: Column[]): string[] {
    const columnNames = ['select'];

    for (const column of columns) {
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
    const numRows = this.dataSource.data.length;
    return numSelected === numRows;
  }

  /** Selects all rows if they are not all selected; otherwise clear selection. */
  masterToggle() {
    this.isAllSelected() ?
      this.selection.clear() :
      this.dataSource.data.forEach(row => this.selection.select(row));
  }

  /** The label for the checkbox on the passed row */
  checkboxLabel(row?: any): string {
    if (!row) {
      return `${this.isAllSelected() ? 'select' : 'deselect'} all`;
    }
    return `${this.selection.isSelected(row) ? 'deselect' : 'select'} row ${row.position + 1}`;
  }

  onAddClicked() {
    const dialogRef = this.dialog.open(RowAddEditViewComponent, {
      width: '700px',
      data: {
        tableName: this.tableName,
        columns: this.columns,
        data: null,
        isAddMode: true
      }
    });

    dialogRef.afterClosed().subscribe(forceRefresh => {
      if (forceRefresh) {
        this.getTableData();
      }
    });
  }
  
  onEditClicked() {
    const dialogRef = this.dialog.open(RowAddEditViewComponent, {
      width: '700px',
      data: {
        tableName: this.tableName,
        columns: this.columns,
        data: this.selection.selected[0],
        isAddMode: false
      }
    });

    dialogRef.afterClosed().subscribe(forceRefresh => {
      if (forceRefresh) {
        this.getTableData();
      }
    });
  }

  onDeleteClicked() {
    const ids = [];

    for (const selected of this.selection.selected) {
      ids.push(selected[0]);
    }

    const deleteRowsUrl = `/api/table/${this.tableName}`;

    const options = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
      }),
      body: ids
    };

    this.httpClient.delete(deleteRowsUrl, options).subscribe(() => { 
      this.getTableData();
    }, (error) => {
      this.toastr.show(error.message);
    });
  }

}
