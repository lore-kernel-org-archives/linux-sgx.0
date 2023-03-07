Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D0E3C6FA99
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Mar 2023 23:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjCGXcf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Mar 2023 18:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjCGXce (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 7 Mar 2023 18:32:34 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67FA212F15
        for <linux-sgx@vger.kernel.org>; Tue,  7 Mar 2023 15:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678231951; x=1709767951;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VmW42qTzAw62uEukhthzRht0UqSZ/1USHPHd2DuXsy0=;
  b=bZtCEWZbQWWHK1fbQCodRWA7Sj1oG2wVpxTQK2wf0qg3zGQYngP660SX
   E2GtoSCFp03W1TDDJwCoWlAi7u5kxgNpj9FWRrGRYVR+k+R+0woj5ytny
   NZEtj4InD3KWuaFnt4Ln1VXOYsnOeM2Tyaw9XdVKnihdlh2KTHV2w1OGa
   Fe+6NMTG9k91obu339r8Ll9RU5DeCjKhK/UCVXR10QmMa0zbCx+04AaMG
   QTiLz2vabLgmoJNeBPM5hrr/oLF3d51B1ZFtj8HxB3y5Kls9kuLGVtnPl
   IXbw7PDKaMCXj9i/ospRHSBarEXB7S0Q/XXelQUIvoILvv3y3JyHk6Ohr
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="422273759"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="422273759"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 15:32:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="676736295"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="676736295"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 07 Mar 2023 15:32:19 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 15:32:19 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 15:32:18 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 7 Mar 2023 15:32:18 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 7 Mar 2023 15:32:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C0TLLl8zksRUa3wLo+AKiNyFXV1QOvmrreTF2J6D9fMP0Sj7eFiiMwiIYLwd7GO+Xn8jU76UaMSDsQYGiTfLOB91FIlkmHxwwPvd7uZzreHgEBpoHJYU6R6ctXfLG3BK8GMJHLLP0D7q3rjnIa1fQYzbvl0AoX2koggkbNAxC9Yzf7CCcu57bnLRM2qE8DlVhyZlvAx1msHW9pGHHxhOU5we1w+7qSOk9bfhLMkg32EF/7j4JV01b9+TBT+HKf88Ta/lqsETShiNyTTSoEmGt+JOLykiqYZUlPJhlqSLBJ09EHcS4kMOtDVNhw/O+iw2zh5+g9TdjvaWC2rKqj+LyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VmW42qTzAw62uEukhthzRht0UqSZ/1USHPHd2DuXsy0=;
 b=MqaxdvCsXD8zRPl/h5PRLNdECh4WqrwZsfVUmaYc/AwNSTSa3x7NVU2IMhR3zds1kAr+Z/rDFoplrQYMYTFt/A7lvCywfIm2+xX2oFgOsPxEEE3HFR2Xq/6VjC/ZIRqWKzWu8UrVA1v1e77C1CdNmQGeaXJRLhAsrzTxDpFxNJ33Ei7CouzcrbWS22cgyHlnCy0zmmmldJEwd6KveAiXPASZJAD56PlUFUZevXrjv7mBNAQTQUDP5TFAjZYyEGqe7iMi6rf7XJ4Cl5WS/L8aeGF3huSSlcQdRJctxdM+ZnMvAB0mYxY9m1sfIH6b/xeOvbpCtp6eo4Hf393TCXPbpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB6682.namprd11.prod.outlook.com (2603:10b6:510:1c5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Tue, 7 Mar
 2023 23:32:15 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%4]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 23:32:15 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "jarkko@kernel.org" <jarkko@kernel.org>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Topic: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Index: AQHZMtTIU78a0A3o9UaUPrwPUmNX5q7OTQIAgACfroCAABrOAIAADTuAgAAPNoCAAFobgIAAUaaAgABy3wCAA5ciAIAACKGAgAY6gQCAADnpAIAV3bGA
Date:   Tue, 7 Mar 2023 23:32:15 +0000
Message-ID: <5de607230294552829b075846a66688f65f3f74e.camel@intel.com>
References: <3c7b4f7bf3e7c2a213662b1c9fdaa979050a9327.camel@intel.com>
         <op.10dekzjhwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <39903b057751d963e4e9b2a8cd5271fe3c102509.camel@intel.com>
         <op.10dk8lsjwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <c37bb20995f234aa724724a06c96c76f18252e66.camel@intel.com>
         <op.10d2otjlwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <ef4087489625b0f8403c38e61348010dba62f623.camel@intel.com>
         <op.10ey84qywjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <Y/AAbC/j04aUkd8R@kernel.org>
         <op.10i8zfw3wjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <Y/VBOkmi7VbVuzAh@kernel.org>
         <op.10qusgctwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <op.10qusgctwjvjmi@hhuan26-mobl.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB6682:EE_
x-ms-office365-filtering-correlation-id: 5b35a0ee-1e08-4f32-42e2-08db1f642f43
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sLjCMbtb/newMbmeU8ldG4DB2M+Tom3qqrs3d+k3FNKzJ5lPI5khjjTG75lKyungbvaj3VEV5NPy2qrJjv+0GLkQydjNi1UlWLxIcLn23/hK3cLT225y9HQlQNd7wAO0ki1qKtmRT6kUidOzC2cK7BYbonlO82WAWBmyK5YBZQbg94a92DY9MDqIOBz+VI2NZFqqftWYZl9KygXdcoj74X3oGHnbUZtYEPrbAt7TGR2qk2+AsAxk1Hr/ic0WRhx9WNBe5wmNfRQkidQGv1EVo2ASs1g2XA7WcvDa2RnGptgsTW6bzUcEIc9FiWo7Zu/K87PLyrU2KkUh5WxwFlR02xWIZFY/aVrsRMrRVzf8YS3PZWQVhhe27iWIkt5mMyIkoBJhVTJOp3qyAcMdTSNp5p2dcVIuPmpRzzRcVPOL8MG0KtByuY5o7xG89L6ZLtKf2D5sR4Djd0kpJHUOutcsdLYZFxSyBPIMhGVy8JBGy7lCHX4jpQFekdbaCcK426fQ0nqLFjy3UdJ3uKE6+d1EJ+vVd+zSXjhdugkhWjl5eeEuryxcKv2kM6/ptN7G/DNzI45W8ZOmbilW2VfMJeVQH+BBrv+W14pIHmYGlNmptLtvysrJHwC/Mbt/ABgMOV1aYEkkq+FFEFNAJgUhoTFThCWs4XMfPK5UIXd2uNavR3HyjrEJHJIw+9EQsnoDu91vQoamacp8nRwKMuTRSSUcdA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(396003)(39860400002)(136003)(376002)(451199018)(82960400001)(86362001)(122000001)(38100700002)(66476007)(38070700005)(36756003)(76116006)(2906002)(71200400001)(66946007)(5660300002)(41300700001)(66556008)(66446008)(4326008)(64756008)(8936002)(8676002)(186003)(2616005)(26005)(6512007)(6506007)(83380400001)(54906003)(478600001)(91956017)(110136005)(316002)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?di9Rbkx3Z0VLdVFPMytORGFqV2V2NGFoMHhuMS9TbGtIcVMzZFdvNmxQeEQv?=
 =?utf-8?B?M1pHTDlSVlhDdVpLUHRzVWxBMEo4VkJaME9tQ0FiTTkzdGdETW1UUFNDTmRz?=
 =?utf-8?B?NXl4eDZ6ZUp6em9XandkVERTaGw5bUJwUG5mUDAwU0J1YUZudGhTU09Jcm4v?=
 =?utf-8?B?cEdvUGJTV3duUWhTeEdCbVg3RTBRb3NxZ2lCeEUraXArb2dCRGg0OW1JU1Ew?=
 =?utf-8?B?TmFDd0Y3ZDZCMUVvMWRFeEM5ZTJDNnFQWVU1OU9Qbk1rNlQzUHBCaFNlQTlE?=
 =?utf-8?B?ZExBQVBiVHVCUEJWNzhNVzFRb2VVcU02M1dTVTBJN1hJblcyc0N0aXBPdHQx?=
 =?utf-8?B?QkI0YmhhWjdZaGZtMytBdCtRYVduZk9mem14Wnk3OWZoMHU1VnVFVjlWWjdr?=
 =?utf-8?B?akRkVHUyV1B0OU5CL3pHV1k0SC9zdVdFUWltanNmNVdnWFZJYlVXZkZ1V2RG?=
 =?utf-8?B?Y2FmbVMzNFZ2N0pmamsvU2l2L1VvSUtURVNTV1VxVWJhVDBYTVZsbXZEeGJ2?=
 =?utf-8?B?SDlkUVlUanpiSGJEUDhCVTlrUWpLOXNFc3F2YzBjUVk1djlnZWRIZ2RlNkxW?=
 =?utf-8?B?VXdxbWkvUTRWQW1TQ0VLY0RORzhEN0NhUk1tcEJwdEJoVFllQ0U4RGsxOUJP?=
 =?utf-8?B?QVBYQ1czemMwamN5MWZlNE1UaWJQVkhRdEgwUnBRb2dsUmptUmZQOUFVams5?=
 =?utf-8?B?MHRjSkNNSkZNTWhBOVVPWXphNmJkSnpHRGxqL0FrVXpvRFlrdFE4dUUyS2dz?=
 =?utf-8?B?OTRVR1Iya2JKMEkrVHh0UGVCVUN3b0FWU2JOaEtGMThiK2REeWNBazZ4Qk5W?=
 =?utf-8?B?N0Riazd6elRDRloxenZDNVE0bEsra1VrMEhveFFTZzMxdDZjY2NCejFNbUlO?=
 =?utf-8?B?b3BXYm1hM2hGQzcvdklHN3VVZmNRQUtEOE5EaGNFVHhHL3ZGb2t6Y2xsM1cv?=
 =?utf-8?B?dFlFSUZnSHNEb1N6NEF1RHFZai9ET3NyNDJBZzBYUGRTNU1BSUs5WHhQN3NZ?=
 =?utf-8?B?aWd3QThzMEdQZG9ET0thMVVSOExUK1M2MUtLQVFvQUl2S3o0S3QzWmFBUHVa?=
 =?utf-8?B?aXc3a0w5Y0NrbHJadUJvTFk3a01pUUpFNHIxRXJHZitLQkF1MXlwYTdYNm5y?=
 =?utf-8?B?am5rSUYyckNrUkozMklkeXlHWmp3amY3alowUkd4end4T01hT1FYNGpSZEp3?=
 =?utf-8?B?Mkk1Qit4YWU1L0VrZGVTU1hQTXZMN0ZZTWhkZWFWZFkrQWIxUDBIV2tDL1Bn?=
 =?utf-8?B?OExuSEk5aHNkYVFYUkQzOE91Y0doWUF6cmdCRjJmRWkwNTRUdWtkTmdyY3FL?=
 =?utf-8?B?aldQTUtMWFFMNjFBRXdMTUdqMFZOQnhQd0dXa1VpN1A5cHU3aWNYYWpyYVE5?=
 =?utf-8?B?UEx5WHVYN1F6NGFvTlVvcHQwQW9kOEtZTmNFMS9jdnhaWVh4MWl1cTRFMDVi?=
 =?utf-8?B?Z3RXRWQyMi9xNHNPOFdRMWdQNk1ERUhCaHRzY0l5UDdhaVZ3eGRIUmhLakZT?=
 =?utf-8?B?d2tQclZBN0RwcktxWU1IUVlSV3AvNkVpdEFYVnlQVEZMVVM1bHhDb2FlNTJQ?=
 =?utf-8?B?V0tnV296dlA1bDB4eVRLK3NUR0N5K0dycU9qYXdXMElQa2xxOHZTVnorakkr?=
 =?utf-8?B?Snlva2dVMmg5aWFqeU9jMHIyZndPb1pMMWpsSDRwVUtxTEx2Ylo0TmxaVENX?=
 =?utf-8?B?SER2eUlpcXRJaFhQSUdvWUt6b0M4NGpFays4SmJHR3EyUVBNeTB1UlBYSVVB?=
 =?utf-8?B?dDdUd3VpMnBKMnpLbUlTakpuOW92eXBGTEZXbDlhelFJQTRpTjFsOG04SU0x?=
 =?utf-8?B?dXVpZmxrVlNzcnlUSU1aa1ZVRWtHTDArOE5abXZQT2JrQkdNaVRLSTZZWmk3?=
 =?utf-8?B?S1NlL2VNRGhGMFhrV2hMemdJc3Z0MWl5cllWTmpJVG1JVlRyaFJHaTdwOWw3?=
 =?utf-8?B?MUZqN3UyUkxweCtSSFZsYkpnQTl0am9JeENhU3RiMS9MSCtuV3orbW5aV2pB?=
 =?utf-8?B?RDk4eWZYY1M0bXlzT1haQ1VMRVNmRlMvYjBWY1V2QVM1YkxrVEtxMHdLMHRT?=
 =?utf-8?B?Q09ialRDS1lYSHYzandXY08yQW5uYXJwd2JSYzFxbHRmYWdEdlB2d3NvWnpJ?=
 =?utf-8?B?WFAvSGdFZHV4ZUlZdXpKVHVtSTRiZWlkbm5rRnZnaHhuRW9PSnkyd0NiZzNn?=
 =?utf-8?B?d1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <53F4947A1098B343A2D8C90FCA23B0FB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b35a0ee-1e08-4f32-42e2-08db1f642f43
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2023 23:32:15.2560
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FIB3hsleX9tR9zkv7dMzmd6zdkIz9KUYIKYxJAhs3vI4tIeg2JAAY9kCgbUWTxQjVpYusi0Mpd972ZXdqBc+yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6682
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gVHVlLCAyMDIzLTAyLTIxIGF0IDE5OjM3IC0wNjAwLCBIYWl0YW8gSHVhbmcgd3JvdGU6DQo+
IE9uIFR1ZSwgMjEgRmViIDIwMjMgMTY6MTA6MDIgLTA2MDAsIGphcmtrb0BrZXJuZWwub3JnIDxq
YXJra29Aa2VybmVsLm9yZz4gIA0KPiB3cm90ZToNCj4gDQo+ID4gT24gRnJpLCBGZWIgMTcsIDIw
MjMgYXQgMDU6MDM6MDVQTSAtMDYwMCwgSGFpdGFvIEh1YW5nIHdyb3RlOg0KPiA+ID4gSGkgSmFy
a2tvDQo+ID4gPiANCj4gPiA+IE9uIEZyaSwgMTcgRmViIDIwMjMgMTY6MzI6MTIgLTA2MDAsIGph
cmtrb0BrZXJuZWwub3JnICANCj4gPiA+IDxqYXJra29Aa2VybmVsLm9yZz4NCj4gPiA+IHdyb3Rl
Og0KPiA+ID4gDQo+ID4gPiA+IE9uIFdlZCwgRmViIDE1LCAyMDIzIGF0IDA5OjQyOjMwQU0gLTA2
MDAsIEhhaXRhbyBIdWFuZyB3cm90ZToNCj4gPiA+ID4gPiBPbiBXZWQsIDE1IEZlYiAyMDIzIDAy
OjUxOjIzIC0wNjAwLCBIdWFuZywgS2FpIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiA+ID4gPiA+
IHdyb3RlOg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4g
PiANCj4gPiA+ID4gPiA+ID4gPiBTaW5jZSBzZ3hfbW1hcCgpIGNhbiBoYXBwZW4gYmVmb3JlIGVu
Y2xhdmUgaXMgY3JlYXRlZCwNCj4gPiA+ID4gPiBjYWxjdWxhdGluZyB0aGUNCj4gPiA+ID4gPiA+
ID4gPiB2bV9wZ29mZg0KPiA+ID4gPiA+ID4gPiA+IGZyb20gZW5jbGF2ZV9iYXNlIGlzIGNvbmNl
cHR1YWxseSB3cm9uZy4gIEV2ZW4gaWYgeW91IHJlYWxseSAgDQo+ID4gPiB3YW50DQo+ID4gPiA+
ID4gPiA+IHRvIGRvDQo+ID4gPiA+ID4gPiA+ID4gaXQsIGl0DQo+ID4gPiA+ID4gPiA+ID4gc2hv
dWxkIGJlOg0KPiA+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiA+IAlpZiAoZW5jbGF2ZV9o
YXNfaW5pdGlhbGl6ZWQoKSkNCj4gPiA+ID4gPiA+ID4gPiAJCXZtYS0+dm1fcGdvZmYgPSAuLi47
DQo+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiBJIGdvdCB5b3VyIHBvaW50IG5vdy4gSSBj
YW4gYWRkIGEgY29uZGl0aW9uIHRvIHRlc3QgdGhlDQo+ID4gPiA+ID4gU0dYX0VOQ0xfQ1JFQVRF
RA0KPiA+ID4gPiA+ID4gPiBiaXQuIEhvd2V2ZXIsIHdlIHN0aWxsIGhhdmUgYSBob2xlIGlmIHdl
IG11c3QgaGFuZGxlIHRoZSAgDQo+ID4gPiBzZXF1ZW5jZQ0KPiA+ID4gPiA+ID4gPiBtbWFwKC4u
LiwgZW5jbGF2ZV9mZCkgYmVpbmcgY2FsbGVkIGJlZm9yZSBFQ1JFQVRFIGlvY3RsLiBXZQ0KPiA+
ID4gPiA+IGNhbid0IGxlYXZlDQo+ID4gPiA+ID4gPiA+IHZtX3Bnb2ZmIG5vdCBzZXQgZm9yIHRo
b3NlIGNhc2VzLg0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gU2luY2Ugbm8gb25lIGRv
ZXMgdGhhdCBzbyBmYXIsIGNhbiB3ZSBleHBsaWNpdGx5IHJldHVybiBhbiBlcnJvcg0KPiA+ID4g
PiA+IGZyb20NCj4gPiA+ID4gPiA+ID4gc2d4X21tYXAgd2hlbiB0aGF0IGhhcHBlbnM/DQo+ID4g
PiA+ID4gPiA+IE90aGVyIHN1Z2dlc3Rpb25zPw0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBB
cyBJIHJlcGxpZWQgdG8gcGF0Y2ggNC80LCBJIGJlbGlldmUgdXNlcnNwYWNlIHNob3VsZCBwYXNz
IHRoZSAgDQo+ID4gPiBjb3JyZWN0DQo+ID4gPiA+ID4gPiBwZ29mZiBpbg0KPiA+ID4gPiA+ID4g
bW1hcCgpLiAgSXQncyB3cm9uZyB0byBhbHdheXMgcGFzcyAwIG9yIGFueSByYW5kb20gdmFsdWUu
DQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IElmIHVzZXJzcGFjZSBmb2xsb3cgdGhlIG1tYXAo
KSBydWxlLCB5b3Ugd29uJ3QgbmVlZCB0byBtYW51YWxseSAgDQo+ID4gPiBzZXQNCj4gPiA+ID4g
PiA+IHZtX3Bnb2ZmDQo+ID4gPiA+ID4gPiBoZXJlICh3aGljaCBpcyBoYWNreSBJTUhPKS4gIEV2
ZXJ5dGhpbmcgd29ya3MgZmluZS4NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+
IFNHWCBkcml2ZXIgd2FzIGZvbGxvd2luZyBNQVBfQU5PTllNT1VTIHNlbWFudGljcy4gSWYgd2Ug
Y2hhbmdlIHRoYXQsDQo+ID4gPiA+ID4gaXQnZA0KPiA+ID4gPiA+IGJyZWFrIGN1cnJlbnQgdXNh
Z2UvQUJJLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IEkgc3RpbGwgdGhpbmsgcmV0dXJuaW5nIGVy
cm9yIGZvciBjYXNlcyBtbWFwKC4uLiwgZW5jbGF2ZV9mZCkgaWYNCj4gPiA+ID4gPiBlbmNsYXZl
IGlzDQo+ID4gPiA+ID4gbm90IGNyZWF0ZWQgd291bGQgYmUgbGVzcyBpbnRydXNpdmUgY2hhbmdl
Lg0KPiA+ID4gPiANCj4gPiA+ID4gSXMgdGhpcyBzb21ldGhpbmcgeW91IGNhcmUgaW4gU0dYIFNE
Sz8NCj4gPiA+ID4gDQo+ID4gPiA+IEl0IGlzIG5vdCBjYXRlZ29yaWNhbGx5IGZvcmJpZGRlbiBz
byB0aGF0J3Mgd2h5IEknbSBhc2tpbmcuDQo+ID4gPiANCj4gPiA+IFNESyBkb2VzIG5vdCBjYXJl
IGFzIHdlIHdvdWxkIG5ldmVyIGRvIHRoaXMgYW5kIGRvbid0IHRoaW5rIGFueW9uZSBpcyAgDQo+
ID4gPiBkb2luZw0KPiA+ID4gdGhhdCBlaXRoZXIuIFN1Z2dlc3RpbmcgcmV0dXJuaW5nIGVycm9y
IHRvIGNvdmVyIGFsbCBjYXNlcyBzbyB1c2VyIHNwYWNlDQo+ID4gPiB3b3VsZCBub3QgYWNjaWRl
bnRhbGx5IGNhdXNlIGluY29ycmVjdCB2bV9wZ29mZiBzZXQuDQo+ID4gDQo+ID4gdm1fcGdvZmYg
IT0gMCBzaG91bGQgcmVzdWx0IC1FSU5WQUwuDQo+ID4gDQo+IA0KPiBEbyB5b3UgbWVhbiAnb2Zm
c2V0JyBwYXNzZWQgaW4gZnJvbSBtbWFwIHN5c2NhbGwgYW5kIGNvbnZlcnRlZCB0byBwZ29mZiBp
biAgDQo+IGtlcm5lbD8gSSBjYW4gc2VlIGl0IG9ubHkgcGFzc2VkIHRvIGRyaXZlciBpbiBnZXRf
dW5tYXBwZWRfYXJlYS4gSSBjYW4gYWRkICANCj4gdGhpcyBlbmZvcmNlbWVudCB0aGVyZSBzbyBp
dCBpcyBjb25zaXN0ZW50IHRvIHRoZSBNQVBfQU5PTllNT1VTIHNwZWMgaWYgIA0KPiB0aGF0J3Mg
d2hhdCB5b3Ugc3VnZ2VzdC4NCj4gDQo+ICAgdm1hLT52bV9wZ29mZiBpcyB0aGUgb2Zmc2V0IGlu
IHBhZ2VzIG9mIHRoZSB2bWEtPnZtX3N0YXJ0IHJlbGF0aXZlIHRvICANCj4gJ2ZpbGUnLg0KPiAg
IEl0IGNhbiBub3QgYmUgemVybyBmb3IgYWxsIFZNQXMgb2YgdGhlIGVuY2xhdmUuDQo+IA0KPiBL
ZXJuZWwgc2V0cyB2bWEtPnZtX3Bnb2ZmID09IHZtYS0+dm1fc3RhcnQ+PlBBR0VfU0hJRlQgZm9y
IHByaXZhdGUgYW5vbiAgDQo+IFZNQXMsIGFuZCBpZ25vcmUgaXQgKHplcm8pIGZvciBzaGFyZWQg
YW5vbiBtYXBwaW5nLg0KPiANCj4gRm9yIHVzLCB3ZSBwcm9wb3NlIHRvIHNldCBpdCB0byBQRk5f
RE9XTih2bWEtPnZtX3N0YXJ0IC0gZW5jbC0+YmFzZSkgdXBvbiAgDQo+IG1tYXAuDQoNClNvcnJ5
IGZvciBsYXRlIHJlcGx5LiAgQmFzaWNhbGx5IEkgd2FzIHNpY2sgYW5kIGhhdmluZyBsaW1pdGVk
IHdvcmtpbmcgdGltZSBpbg0KdGhlIHBhc3NlZCB0d28gd2Vla3MuDQoNCkZvciB3aGF0IEkgdW5k
ZXJzdGFuZCBub3csIFNHWCBkcml2ZXIgd2FudHMgdG8gdXNlIE1BUF9BTk9OWU1PVVMgc2VtYW50
aWMgZm9yDQptbWFwKClzIGFnYWluc3QgL2Rldi9zZ3hfZW5jbGF2ZSAoZm9yIHdoYXRldmVyIHJl
YXNvbiB0aGF0IEkgZG9uJ3QgdW5kZXJzdGFuZCkuwqANCg0KQW5kIGJlY2F1c2Ugb2YgdGhhdCwg
d2UgZXZlbiB3YW50IHRvIGV4cGxpY2l0bHkgZW5mb3JjZSB1c2Vyc3BhY2UgdG8gYWx3YXlzIHBh
c3MNCjAgYXMgcGdvZmYgaW4gbW1hcCgpcyAoaGFzbid0IGJlZW4gZG9uZSB5ZXQpLg0KDQpBbmQg
dGhlbiBoZXJlLCB3ZSB3YW50IHRvIHJld3JpdGUgdm1hLT5wZ29mZiBzbyB0aGF0IHRoZSBWTUEg
Y2FuIGFjdCBfbGlrZV8gYQ0Kbm9ybWFsIGZpbGUtYmFzZWQgbW1hcCgpIHNlbWFudGljcyAoZGVz
cGl0ZSBpdCBpcyBpbmRlZWQgYSBmaWxlLWJhc2VkIFZNQSksDQpiZWNhdXNlIHRoZSBWRlMgZmFk
dmljZSgpIGltcGxlbWVudGF0aW9uIGFzc3VtZXMgZmlsZS1iYXNlZCBWTUFzIGFyZSBhbHdheXMN
CmZvbGxvd2luZyBmaWxlLWJhc2VkIG1tYXAoKSBzZW1hbnRpY3MuDQoNCkhtbS4uDQoNCkRvZXNu
J3QgdGhpcyBzb3VuZCB3ZWlyZD8NCg0KSSBtdXN0IGhhdmUgYmVlbiBtaXNzaW5nIHNvbWV0aGlu
ZywgYnV0IHdoeSBjYW5ub3QgU0dYIGRyaXZlciBqdXN0IGFsd2F5cyBmb2xsb3cNCmZpbGUtYmFz
ZWQgbW1hcCgpIHNlbWFudGljcyBhdCB0aGUgYmVnaW5uaW5nPw0KDQpGb3IgaW5zdGFuY2UsIHdo
YXQncyB3cm9uZyB3aXRoOg0KDQoJMSkgZW5jbF9mZCA9IG9wZW4oIi9kZXYvc2d4X2VuY2xhdmUi
KQ0KCTIpIGVuY2xfYmFzZSA9IG1tYXAoLi4uLCBlbmNsX3NpemUsIE1BUF9TSEFSRUQsIGVuY2xf
ZmQsIDAgLyogcGdvZmYgKi8pDQoJMykgaW9jdGwoRUNSRUFURSwgZW5jbF9iYXNlLCBlbmNsX3Np
emUpDQoNCihJbiBpb2N0bChFQ1JFQVRFKSwgd2UgbWlnaHQgd2FudCB0byB2ZXJpZnkgdGhlIFZN
QSB3ZSBmb3VuZCBoYXMgdGhlIHNhbWUNCmVuY2xfYmFzZSBhcyBzdGFydGluZyBhZGRyZXNzLCBh
bmQgMCBwZ29mZikuDQoNCkFuZCBpbiBmb2xsb3dpbmcgbW1hcCgpcyBpbiB3aGljaCB3ZSB3YW50
IHRvIG1hcCBhIHNtYWxsIHJhbmdlIG9mIGVuY2xhdmU6DQoNCgllbmNsX2FkZHIgPSBtbWFwKGVu
Y2xfYWRkciwgTUFQX1NIQVJFRHxNQVBfRklYRUQsIGVuY2xfZmQsDQoJCQkoZW5jbF9hZGRyIC0g
ZW5jbF9iYXNlKSA+PiBQQUdFX1NISUZUKTsNCg0KPw0KDQpBbnl0aGluZyB3cm9uZyBhYm92ZT8N
Cg0KSW4gZmFjdCwgaWYgdGhlIGZpcnN0IG1tYXAoKSBpbiBzdGVwIDIpIGJlZm9yZSBJT0NUTChl
Y3JlYXRlKSB1c2VkDQpNQVBfQU5PTllNT1VTLCBJSVVDIHRoYXQgVk1BIHdpbGwgc3RheSBhcyBh
bm9ueW1vdXMgVk1BIGJ1dCB3aWxsIG5ldmVyIGJlDQpjb252ZXJ0ZWQgdG8gU0dYIGZpbGUtYmFz
ZWQgb25lLCBiZWNhdXNlIGJ5IGxvb2tpbmcgYXQgdGhlIGNvZGUsIEkgc2VlIG5laXRoZXINCmlv
Y3RsKEVDUkVBVEUpIG5vciBpb2N0bChFSU5JVCkgY29udmVydHMgdGhhdCBWTUEgdG8gZmlsZS1i
YXNlZCBvbmUuDQoNClRoYXQgYmVpbmcgc2FpZCwgYWxsIHBhZ2UgZmF1bHRzIGNhdXNlZCBieSB1
c2Vyc3BhY2UgYWNjZXNzIHRvIHRoYXQgVk1BIHdpbGwNCnN0aWxsIGdvIHRvIGFub255bW91cyBW
TUEncyBmYXVsdCBwYXRoLCBidXQgbm90IFNHWCBkcml2ZXIncy4NCg0KVGhpcyBpcyBmaW5lIGZv
ciBTR1gxIGFzIGFsbCBlbmNsYXZlIHBhZ2VzIGFyZSBmdWxseSBwb3B1bGF0ZWQuICBGb3IgU0dY
MiwNCl91bmxlc3NfIHlvdSBleHBsaWNpdGx5IG1tYXAoIi9kZXYvc2d4X2VuY2xhdmUiKSB0aG9z
ZSBkeW5hbWljYWwgcmFuZ2VzLCB0aGUNCmZhdWx0IHdpbGwgbmV2ZXIgYmUgaGFuZGxlZCBieSBT
R1ggZHJpdmVyLg0KDQpBcmNoaXRlY3R1cmFsbHksIGZvciBTR1gyLCBpZiB5b3UgbW1hcCgpIHRo
ZSBlbnRpcmUgZW5jbGF2ZSByYW5nZSAoYXMgaW4gc3RlcA0KMiksIHlvdSBkb24ndCBuZWVkIGV4
cGxpY2l0bHkgbW1hcCgpIGFsbCBkeW5hbWljIHJhbmdlcy4gIFRoZSB1c2Vyc3BhY2Ugc2hvdWxk
DQpqdXN0IGJlIGFibGUgdG8gYWNjZXNzIHRob3NlIGR5bmFtaWMgcmFuZ2VzIChpLmUuIEVBQ0NF
UFQpIGFuZCB0aGUga2VybmVsIGRyaXZlcg0Kc2hvdWxkIGdyYWNlZnVsbHkgaGFuZGxlIHRoZSBm
YXVsdC4NCg0KU2hvdWxkbid0IHRoaXMgYmUgYSBwcm9ibGVtPw0KDQooQnR3LCB0aGVyZSBtaWdo
dCBiZSBvdGhlciBjb3JuZXIgY2FzZXMgdGhhdCBjb3VsZCBjYXVzZSBWTUEgc3BsaXR0aW5nL21l
cmdpbmcsDQpldGMsIGJ1dCBJIGhhdmVuJ3QgdGhvdWdodCBhYm91dCB0aG9zZSkNCg0KDQo+IFRo
ZSBjb25jZXJuIEthaSByYWlzZWQgYWJvdXQgZW5jbC0+YmFzZSBub3QgYXZhaWxhYmxlIGluIHRo
ZSB3aW5kb3cgIA0KPiBiZXR3ZWVuIG1tYXAgYW5kIEVDUkVBVEUgY2FuIGJlIGFkZHJlc3NlZCBi
eSBkaXNhbGxvd2luZyBtbWFwIGJlZm9yZSAgDQo+IEVDUkVBVEUgaXMgZG9uZS4gSXQgZG9lcyBu
b3QgbWFrZSBtdWNoIHNlbnNlIGFueXdheSB0byBtbWFwKGVuY2xhdmVfZmQpICANCj4gd2l0aG91
dCBhIHZhbGlkIGVuY2xhdmUgcmFuZ2UgYXNzb2NpYXRlZCB3aXRoIGVuY2xhdmVfZmQuDQo+IA0K
DQpXZSBjYW4sIGJ1dCBJIGRvbid0IHVuZGVyc3RhbmQgd2h5IHRoZSBmaXJzdCBtbWFwKCkgYmVm
b3JlIEVDUkVBVEUgbXVzdC9zaG91bGQNCmJlIGRvbmUgdmlhIE1NQVBfQU5PTllNT1VTLiAgSW4g
ZmFjdCwgSSB0aGluayBpdCBtaWdodCBiZSB3cm9uZyBmb3IgU0dYMi4NCg0KDQoNCg0KDQo=
