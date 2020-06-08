import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RowAddEditViewComponent } from './row-add-edit-view.component';

describe('RowAddEditViewComponent', () => {
  let component: RowAddEditViewComponent;
  let fixture: ComponentFixture<RowAddEditViewComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RowAddEditViewComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RowAddEditViewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
