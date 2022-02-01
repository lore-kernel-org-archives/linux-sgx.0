Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A4EC433EF
	for <linux-sgx@archiver.kernel.org>; Tue,  1 Feb 2022 14:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239417AbiBAOqu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 1 Feb 2022 09:46:50 -0500
Received: from mail-sn1anam02on2119.outbound.protection.outlook.com ([40.107.96.119]:33611
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239435AbiBAOqu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 1 Feb 2022 09:46:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GrDGsBCO3vsF59LBvi8h/HhNA5d/W7He0BJQaAHrPtNKXwJwhvPH5Y/VdtJQCEkUQpjAXGNznN5ii1vpnwR7JDvuRrgEe1k+JZZNWFeOLei9MVawpjtlNk1zBILHrtJws2adehY+4PRe9XvvrWKWQEh87m35L1kTtMYXMhSY0EFomdV7a4LZ1a3dHfOzdOOJDtGmNL+bpwL3wJ4BWfseb+SJDku8rHWCc0qhgxoS/KqyNI4Bay5c+/W44YeW1atDUFxpFkwVPQKF9yRn07/38B9wBc8Tnv3SUFiamk9PdFXviMr194Yvww3tCqqE8h4qM6asJnY1+HhZuVVBfJ0+UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R9YPQBM1Fql7te9AMLYV8Ti4UBBgs6DlBBPX5Ob7OHc=;
 b=JMCY2EFM+vOCTLE1puuRSquaM0uUu79wSlt0flMV38rhxFd7sYVqvg9zcWWatKAK7Xu2MClI0QpW/B3YXJiZCyXQqsGgcwqce7RAjL3ufCTmHGe77zIL8Gv8dPgz4jGKXDxdZgspLejHJIlqHlBqT6kWO6RAUXV+kUDAPgVeWfGAAgR84qpfr/suvVP06fwHFXwxaC4sAbP7I2eLudsgVPPvUFCDM6KDyMKTllq0LF4pnPoLSGslEf8h585ljBdr6mRvy7pVMzxiG/5b20Fr/InlJouaErh5rjS2rrIoHbuyZ9mXmPfFvshFI8IBMnG2yegOy+HPtvLOPjTDyzzZVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R9YPQBM1Fql7te9AMLYV8Ti4UBBgs6DlBBPX5Ob7OHc=;
 b=KufEoNnM6iThXJGzFmeIVEJ3bNHBTXmmyfCE9JhQxkXHsR/gOYdsptyoK5b+JAiDHD9bF80p6FTFgJ49SKhPeHoPn4AmUOzU8TBXysPdEN4MQeEKhH16BgF+RA5H9ej1SfIq++FNz9jZHyaN/HHcosWS8NCnaSsDRnOxkIphaWA=
Received: from BL0PR2101MB1076.namprd21.prod.outlook.com
 (2603:10b6:207:37::22) by DM5PR21MB2106.namprd21.prod.outlook.com
 (2603:10b6:3:c9::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.4; Tue, 1 Feb
 2022 14:46:46 +0000
Received: from BL0PR2101MB1076.namprd21.prod.outlook.com
 ([fe80::dca:f222:6414:ab78]) by BL0PR2101MB1076.namprd21.prod.outlook.com
 ([fe80::dca:f222:6414:ab78%9]) with mapi id 15.20.4930.009; Tue, 1 Feb 2022
 14:46:46 +0000
From:   Anand Krishnamoorthi <anakrish@microsoft.com>
To:     "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Bo Zhang (ACC)" <zhanb@microsoft.com>
Subject: Re: [PATCH v3 1/2] x86/sgx: Add accounting for tracking overcommit
Thread-Topic: [PATCH v3 1/2] x86/sgx: Add accounting for tracking overcommit
Thread-Index: AQHYFsmdjAeRpyCDq0CcLg7nk1G8/ax+xd1T
Date:   Tue, 1 Feb 2022 14:46:45 +0000
Message-ID: <BL0PR2101MB1076F8F66EDF8F2D3214975CC4269@BL0PR2101MB1076.namprd21.prod.outlook.com>
References: <DM5PR2101MB108074567B5D75229FFA6D23C4229@DM5PR2101MB1080.namprd21.prod.outlook.com>
 <75c5aa1a25acaf32a3bd89d62f59f892b676fa90.camel@intel.com>
In-Reply-To: <75c5aa1a25acaf32a3bd89d62f59f892b676fa90.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-02-01T14:46:45.621Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6374582a-c8e2-4bff-b20f-08d9e591ab94
x-ms-traffictypediagnostic: DM5PR21MB2106:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <DM5PR21MB2106D5564C3D2CA2ACFF751FC4269@DM5PR21MB2106.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RrV9WL/ZQGgvSYBLt0CQHS4G5SrZN6OtFaMcuaRJO+I8pBKQdz+KlnG4rUzdQxVZ9mRLZ87G8ndBcBOtxeV6pdkxrLZu0rY+VlfC7+wolgo3Y2RjWXcE9KfdKcXO+nmVXHLagnP6q4yE67bNmDVx3j4KNkGsI17u5s45jQome9oz6JHgiUqxcktyPrYHw2sJqB3niQZvNvjYB3bKkGoM8adNa9DNXCf8lNKDRWaWrsvGT7Q3zcEkksk7U8caS0e6+H8a+Q3xIxfXdJGf1O1N8g5wOfENb1/Gzy+8SmsKHDuZuS9/D1XMelwgkdQ9Bfj+BoqhGLmntQkRZN0rX4LtrHinHi6lW94CgxaQK9W2GTBGcwIVG0P2y3ZkH3ktr+nIS0Y5yvxmGOTTuoJl/c4UN3TSDZV5c4ZDuaBPvebGYODWpcYwZ/Ez1VRXAVZIuIMILftTu0T/aWPx7nYWudTe1NcrdQUOPfUeKGxkNnQ4UejCZuPEbrP2wM0r5H/Rr150N0FZIC3EohDw6R+b/Ple+unTC6GxTztVL0bzRXTfguEscWCULq6TDilS9FvDgmWYcvonjans0eXA6w4XfaPIMMlblBDa7FmU+TaDEhAuL6igG5gtxn7/kz2JRureo1sCtQo6h1aXHn/2/wtHEkBbP8U124Kaq/5uIv81l+QSqPMsaWdBBroIbZ5NAlg+Ejyng/9RwL7TlfZoCy3BVKfobugJxLiCQb57TpXt8PKedvInofALUOJlqRnJCGzM5opF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1076.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(64756008)(66476007)(66946007)(66556008)(66446008)(15650500001)(82960400001)(122000001)(8676002)(76116006)(8936002)(91956017)(86362001)(82950400001)(2906002)(52536014)(110136005)(6636002)(38070700005)(316002)(5660300002)(8990500004)(83380400001)(38100700002)(186003)(71200400001)(55016003)(26005)(33656002)(6506007)(10290500003)(7696005)(53546011)(9686003)(508600001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?b3XVlmEQzl+3KvVp2LqLS3tYRf4ht7cMYqvnz4vFARk6DMv7TnBSdXx/oky2?=
 =?us-ascii?Q?67AH9c4z7wX1p3OBdR5yOusscJ+RzWAYhGuA5QoelAhSXAIrnt5N5F9Lqluf?=
 =?us-ascii?Q?bLqW30457HEedy6ipL2st8tKyN/F2K6EUgDZmX+dsnlPHKhDcJ6WPLOMFfGE?=
 =?us-ascii?Q?Iq5/YDeM2iJPY/Dz2JBlKzxf8OatZiy/QwRwAtQzW7J/1vv1P7J3mfkyaJjV?=
 =?us-ascii?Q?wfMAOCRfqh/sBb00ksUPpYKg2A7N/S0BzwokTuD9GXYbNCLTki3838oTkeQA?=
 =?us-ascii?Q?0CZbUZ/uxvw6KiE/46RQlNXhcrWffSz9R2vVS5AxzL6V1KmQ2JdmADGcDoLU?=
 =?us-ascii?Q?YZ2GFDeKNsramV5o6IA4uJWy82+z/bfoIpG0MvlUvEWD0f8OHiGGZ5mq73u0?=
 =?us-ascii?Q?GJl5gcZeIxZVglO8FXAMfQwFNDGCDuj1z/+2UhZMNHUOas8uOLj9QoZCNi+F?=
 =?us-ascii?Q?SQCsMicCVdRzMGGdHJZQ2d3JDzCChAOuDzF7VG1Xvl7Sx9KB7kjz/RCslXRT?=
 =?us-ascii?Q?C/mRJTcO9nQp91Qa3zn8Ph97aUbCfKTv36fxylGwLr9A8QtQChZcta0OVKsR?=
 =?us-ascii?Q?TsIIHlEuznmT9b+2j81s13UJfrgtV8E0As2MXbaaAyadFStr5wwkhct3irYM?=
 =?us-ascii?Q?dtFSlESKKhxBBKIcr69rkXCNcOYO+B/JbJQi9PwxFdtJV+O4Dh+2Rx3Qrjqh?=
 =?us-ascii?Q?t7fDqHnVqGBFSiiUnGXeDIEmRvdBIF/tC53fAN+xDNsQHfuY2nPck+OthBCH?=
 =?us-ascii?Q?9X/fuHG3x2n6W27NStzUyw0uWLJdH0TufS5p6EIBgxi0MWKoJ7ooCAs/E5J2?=
 =?us-ascii?Q?Alx8w0b0ydWzhynscwnlscQN71oFzt8P1MFyP3rQH4JkR5YMdoEgsTROGiMq?=
 =?us-ascii?Q?zp6314YpnAt55sGXChmWiRjmraSpktcwVuLNwx62Zh7UiqC1u9Mk7iNPGOU0?=
 =?us-ascii?Q?kAVBDslXgXSlnh28UAEiQM8PwJU6vCl1/lf2gU0mne5xFndyK/NeDFA9wlYP?=
 =?us-ascii?Q?hh3uBtZP86Ir2XmKzs1TPpjJdoYDDzLv7PX405NRlOAsHu5/y+OLM1meWDFZ?=
 =?us-ascii?Q?XTxtOMTUR011Lbpf3heLClLIlHGIm05ClDcLBAuuGf7QtoSsTLZnqMNPkefZ?=
 =?us-ascii?Q?Px+nCWnl1YHkgB6ILk2ZUeRxeqfiuKCjOefKsGn1Ge6789uMnaN/ANOYtGO2?=
 =?us-ascii?Q?G3JX8u+DCSve01fe02SHY2W52/zRYGkYPQD4Be4iiUt6W7zlAuUBFdBQJ7fc?=
 =?us-ascii?Q?rColDvpHILlSnus9DD7E+ZiF2SfBreMPNeBUbUvjrNsPvbOrZPOJ4R+uBAEd?=
 =?us-ascii?Q?q9ZwDHBJIdaBriWAq8wGpUqYJ8wlvpPHUQhGsQW2WXX1nW6UvIXxlD193yb1?=
 =?us-ascii?Q?dd1jlvHHEDdJ7A63CG4wl60CQpVWD9lt8hsPZpvXs14rTKLhahaXbFIqbOzh?=
 =?us-ascii?Q?yLQ4GMiTsLTTJ2Pytbr1G+eeIuSbq7e7yPQFHJuoPwyag23/+VmERjqMkFhQ?=
 =?us-ascii?Q?Z+fUmKnxWNQGS7Wy6TVCQygx8B9azmLKmVShYpOBWY09nr9L93eh2I18AeWn?=
 =?us-ascii?Q?LVSXTYtITpZhE7IcbTXiLhWWaROefMQDjMqe4FSmeAImMR7SIL/lYbf/S/Qo?=
 =?us-ascii?Q?AQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1076.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6374582a-c8e2-4bff-b20f-08d9e591ab94
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2022 14:46:45.9353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PcDcNPWcYRe37AcWhsjl0m4WQb7q/JCX0KoIEoVHf3qPHvkyiLdUbcZWvKqs+QLf6v6JP1rwgop8Sdw/kMIKvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB2106
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> A module param which the admin used to
adjust the overcommit percentage was proposed to handle cases like this
where users would want to determine the level of overcommit they
allowed. Would something like this be used by your users?

A module param with a high default value (in GBs for CFL systems) would all=
ow flexibility.
Would changing the module param require a reboot or just a module reload?

________________________________________
From: Accardi, Kristen C <kristen.c.accardi@intel.com>
Sent: Monday, January 31, 2022 9:40 AM
To: linux-sgx@vger.kernel.org; Anand Krishnamoorthi
Subject: [EXTERNAL] Re: [PATCH v3 1/2] x86/sgx: Add accounting for tracking=
 overcommit

On Fri, 2022-01-28 at 01:30 +0000, Anand Krishnamoorthi wrote:
> Some of our users rely on EPC paging to run enclaves that require GBs
> of memory on Coffee Lake VMs with less than 200MB EPC.
> Would the 1.5x EPC backing pages limit prevent these users from
> running their enclaves?
>
> - Anand

If you had 200MB of EPC, you'd be limited to 300MB of backing pages.
The goal of this patch was to prevent users from using up all the
memory on the system with backing pages, which having GB of backing
pages would do pretty quickly. A module param which the admin used to
adjust the overcommit percentage was proposed to handle cases like this
where users would want to determine the level of overcommit they
allowed. Would something like this be used by your users?
