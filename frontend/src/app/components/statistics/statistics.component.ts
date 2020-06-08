import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { ForeignKey } from 'src/models/foreign-key';
import { HttpClient } from '@angular/common/http';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-statistics',
  templateUrl: './statistics.component.html',
  styleUrls: ['./statistics.component.css']
})
export class StatisticsComponent implements OnInit {

  public formGroup = new FormGroup({
    parkingLots: new FormControl(),
    dateFrom: new FormControl(new Date()),
    dateTo: new FormControl(new Date()),
    licensePlate: new FormControl(),
    paymentStatus: new FormControl()
  });

  public parkingLots: ForeignKey[] = [];

  public paymentStatusEnum = ['SUCCESS', 'FAILURE'];

  // chart options
  public chartData = null;
  public view: any[] = [1024, 400];
  public showXAxis = true;
  public showYAxis = true;
  public gradient = true;
  public showLegend = false;
  public showXAxisLabel = true;
  public xAxisLabel = 'Time';
  public showYAxisLabel = true;
  public yAxisLabel = 'Count';
  public colorScheme = {
    domain: ['#5AA454', '#A10A28', '#C7B42C', '#AAAAAA']
  };

  constructor(private httpClient: HttpClient, private toastr: ToastrService) { }

  ngOnInit(): void {
    this.getParkingLots();
  }

  private getParkingLots() {
    this.httpClient.post('api/foreign-keys', ['ParkingLots']).subscribe((foreignKeysMap: { [key: string]: ForeignKey[] }) => {
      const parkingLots = foreignKeysMap.ParkingLots;
      if (parkingLots) {
        this.parkingLots = parkingLots;
      }
    }, (error) => {
      this.toastr.show(error.message);
    });
  }

  generateClicked() {
    if (document.location.port === '4200') { // mock
      this.chartData = [{ name: 'a', value: 8940000 }, { name: 'b', value: 8940000 }, { name: 'c', value: 7200000 }];
    } else {
      this.httpClient.post('api/statistics', this.formGroup.getRawValue()).subscribe((chartData) => {
        this.chartData = chartData;
      }, (error) => {
        this.toastr.show(error.message);
      });
    }
  }

}
