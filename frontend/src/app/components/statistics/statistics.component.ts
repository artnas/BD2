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
    
  }

}
