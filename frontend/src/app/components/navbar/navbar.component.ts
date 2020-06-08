import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.css']
})
export class NavbarComponent implements OnInit {

  public tableNames: string[] = ['Addresses', 'Zones', 'Cameras', 'ParkingLots', 'ParkingMeters', 'Bills', 'Payments', 'Fines', 'EParkingTickets', 'Controllers', 'Users', 'Vehicles'];

  constructor() { }

  ngOnInit(): void {
  }

}
