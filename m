Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E7E0ECAAA1
	for <linux-sgx@archiver.kernel.org>; Mon, 12 Sep 2022 10:01:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiILKBM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 12 Sep 2022 06:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiILKBJ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 12 Sep 2022 06:01:09 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9931E14036
        for <linux-sgx@vger.kernel.org>; Mon, 12 Sep 2022 03:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662976867; x=1694512867;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lqq1hR6oW7nWfaVzxxyJLh8Nz3Tki8krVwkVESqnayE=;
  b=K71cwSxyXlzAlOjzzm6CUzZDJIE9b9Lhe99nHWVjGOwR6puVBK2mBG24
   5arAPEdrtsMZEGo19i7l5jKAtHZS3dWxVkXxjKHt4vZuExtlyccgDKOCG
   4S5ohntgbeNtz8iLriBoi4m5X9SnFl4lq+7zfREPKDZJGax5EyjPXJ6Mn
   IJIN/4dKf34+eZpNQESOkXarMIpcatBeo5hHFaQJleyZNn9pd6xWuxeKj
   rP0uD9Evzoz6lqrIextEe8N+9vFkRIX9wiWYypAwRvW9SyCHWXC/gBcVZ
   p0ykRNlwYacsQMVtIomRjwcP3FA/g66nnTWHLejojhm2lalbBRUdY1S+T
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10467"; a="296562935"
X-IronPort-AV: E=Sophos;i="5.93,308,1654585200"; 
   d="scan'208";a="296562935"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 03:01:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,310,1654585200"; 
   d="scan'208";a="567106623"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 12 Sep 2022 03:01:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 03:01:05 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 12 Sep 2022 03:01:05 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 12 Sep 2022 03:01:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fiEBx3KTiFOBUKyUdRPgqjBXhW1Yr+NlzN8gF5hCCqJBgToz6avOI4UG0D8QT7MAlAQr1Dn1Y2fF1dYMIVZRzkeF3YRp/RaPR4C4pa0MHQegNBDbmh8y2ZchrhDqznzB0SNpIBC4/Ew8vWcwYz5EBgADV/AuFz7tMG+1TFTnt1d+tPllDvf9r+8f33FgVa/k0QFJMmwNeCL7lxUvCqA6lRZtxFtQ6bg+Wk1E1SAfH0ySQSvyNKUT+C4vQ62SEiWVTyq1gp0jlC0zDhhuUtJlCZiWd1zIjfq9EEG36il7UrskF388dr/hPabpSIkxRM+G7CsTW9hHWQZ0fYxUa8W0iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lqq1hR6oW7nWfaVzxxyJLh8Nz3Tki8krVwkVESqnayE=;
 b=DcGt0fbVtusDDrrCrYmPwzzLhVdWXuMBwkT9EiUotUPbvhWynlW/LBiikWLhxQz5vc4+daHWVikxD3B6c+GrnhGJ8dqxoa4DVXj0GHzoEu9eZxcuOd0j0sEoVjJOYfjV/oRP7X09KP+/7Ylf3XiWoADMZ/G6RU8hKJI30OSHb3rHs8hRvoPrOk8b6wkyAl9ilIYFlV8n29ULbHl02kPU4k4XKLQswx1I/kPqXqeGA0C2pXsV/t0k21Dl56iCQwqV0JSZop+SU5o6EEmk0ci/87wBIXPp/Qsd56QrB8B+D5OfuTO0AOqqIoS6F7+GeXprSJXhgPK7SUL8hmXJNu9jGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB4805.namprd11.prod.outlook.com (2603:10b6:510:32::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.16; Mon, 12 Sep
 2022 10:01:00 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::e03d:fd3:dad2:2248]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::e03d:fd3:dad2:2248%6]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 10:01:00 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "Du, Fan" <fan.du@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>
Subject: Re: [PATCH v7 1/3] x86/sgx: Rename the owner field of struct
 sgx_epc_page as encl_owner
Thread-Topic: [PATCH v7 1/3] x86/sgx: Rename the owner field of struct
 sgx_epc_page as encl_owner
Thread-Index: AQHYvZor9AX1oLj3E0WkmXG4tC6J8a3J7OeAgA0tVgCABIesgA==
Date:   Mon, 12 Sep 2022 10:01:00 +0000
Message-ID: <4e0742a835927f45037b18449efe86902e1118ab.camel@intel.com>
References: <20220901003601.2048563-1-zhiquan1.li@intel.com>
         <20220901003601.2048563-2-zhiquan1.li@intel.com>
         <7d222818eabcecc1376c616f8f2fcbb89f0df70e.camel@intel.com>
         <34a15728-af9f-0d75-023f-0b2bc2dced4e@intel.com>
In-Reply-To: <34a15728-af9f-0d75-023f-0b2bc2dced4e@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB4805:EE_
x-ms-office365-filtering-correlation-id: 5c2217b2-0989-4218-eac1-08da94a5b21b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IRQDSAfnLRY7Zr9vIvZOFjjyPTqLOIvv4Tpccl3EqUuyMmzLp9Y2yxYwSgGs536yqC/mM2E71ugornO9XCqhO3vo/eOgSYPF1VMHuxwSwMBwe4euBvmiDkW0KjKjo3nWvSKbMq4A/41xtCJ61Ivi5S2mae//cTjPiJfIbokNQvnXbKld840y2o0uqj06C7Cta9Tu2SI3KtAyhjTm13lgRruFrMBVgI0LS+6j7JUhKx2+XW+DAYKAO41sz/lB9RzKLDB+wiNwnWSVsI3jS9eUEjgjHM8or7+A7MR9boY0WTAKxr8AWqfl8WwwLj0IigInHtqSNIobvvH1XJEmDSs5olMcD9Zz8UiTnRA5BG0OBAh4C1sfyFtj7p3XnvGyF3Y+MPz/yCEfTKP/s/92leqxfP1g+A+giHbM64es7q+him6B/i2ZT8Uu6Pjq23oTWaDP64XZSwLYlErvXlbWnsYN2BV4AH1qh7o7syt/7mLsfKbxt6l8OERXgAz9eso3xDvX+JKiCTKtexk9jPPeb6sRJb64lCi2Su+dbpeOCPgG9/VpF1nd2pAL4nXz7e2x47S7AUUsDkAImUP0zaxJhRp6kl0TugOx2yK9mDnxJvU7c89pSzalKTXnM3sE6Kvhcebos+uuYeFz0eio/arQZmOlJqOcVDZNUcZAKRWYS9FQHnEt86s7sKxVTiAK498Fx2zt1VV3CcKpfM3hP8zRvUGfUN+a1w1yBg4Ft1Wo6cOnMOAU9lA+WyD9flVHEj/Ej2Q2W38BxLShTcc8lmpK0EHdGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(366004)(39860400002)(396003)(376002)(6486002)(38070700005)(478600001)(41300700001)(86362001)(110136005)(54906003)(316002)(6512007)(26005)(6506007)(71200400001)(186003)(82960400001)(36756003)(66446008)(2616005)(122000001)(38100700002)(5660300002)(558084003)(8936002)(8676002)(91956017)(4326008)(66946007)(66476007)(66556008)(64756008)(76116006)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODRVcWw5THd2Ym4zOWExckxrWXNHU2xhOXRuQ0NCSDJCM0Npc1RqNHZwQkVM?=
 =?utf-8?B?Wi9PQ0dLR1M0QkQ2cHYxeWJLNTkwU3d5STgrRFFMSjZPWWJleWRodDVKUFJ1?=
 =?utf-8?B?Vnh4bndlZ09yeFFUYnJWVHRQMk5ETGxiQjlTc0xxMmtvaW94a1pmcStma3ZQ?=
 =?utf-8?B?QkVHZndHbGFrSTNieDlGamNMMm43YnBDT3p5R2ZCVkdGTnVOOFlyM05RcGpF?=
 =?utf-8?B?ODBqL3p1ZGFpaG51dE9uOUh0bkVWQ1pJY2UrbVMvYlJuQXpvVVFiK1JNTzhr?=
 =?utf-8?B?Z29PdXBqWXc4bGFOcU9xZzRUYmZxQ1NBUHhzMlJPcHB4ZFJkaWM4TkJOdnRW?=
 =?utf-8?B?anBkbmJ4bHB4cDBabUQrTytNVVdiMWU2QU5YOVljMi9jTlRzRndsWUFEL1Fo?=
 =?utf-8?B?TWY3NERuWFpDWDQzMmFzdVJpdjVmT09DUlZyVHZVUXZKNHcybGNVaGcyR01x?=
 =?utf-8?B?RDUyOThPcVZ0dWhQTFlNdTlQSGRvbzIxS1NUZmhkZEpwdzRuTG9CNGwySHZq?=
 =?utf-8?B?SUhaSGxUQy9mUUJyUUkvS3JZa3ZEU0ljREh4TDFOQVhhcGRwZU0wYVl6K09h?=
 =?utf-8?B?Z0g4WDVXYW5xQ3R6c3Z0M245VnhTd3RMZHE3QXZQbzdQMzYrU0d3eXQwZ1JS?=
 =?utf-8?B?dEJ3TzdJTzROei9pMUxHZEFwaDVZcThuUE81cmJQNWFTd1I4bE83andNdlRn?=
 =?utf-8?B?Qm1VN0xpM01vZ2U1eE9vS0YwWmd6R1RWTUhVUEd6enFZNUN2OEtTYkN1VzVo?=
 =?utf-8?B?SzRRK3JkZHZNL3FsZ2ZGOEtBLzc0QVYzY1Fxbk9KUTM2LzliQnhtaHBtSmlV?=
 =?utf-8?B?K2NqSG05bmtmNVFRa3JNazRRbGdwbmZPY3ZaaS9PUzM4eExmVlBtRFNvMVpZ?=
 =?utf-8?B?MVZ4YUp2NXdoR0VWbmUzZXBoQTZyd05KWXRmbGE2RFEyUG1XdUpvdFUzVnJL?=
 =?utf-8?B?WnJHRGVuUnF1aWc0dkFac2k4NVVweEl0anJmeGxubmRHZzlBL0lyekNXbmt3?=
 =?utf-8?B?QWFkQ0x0V2VQRHhSTUJKM3FyNVNVa202ZTQ2NEhQSFVzaHFpTUQyeEpQS3JW?=
 =?utf-8?B?amxobmJJMXZST24vLzdMSDBFNnExalBzQTFBTEEyaTUvcXNvaDI0TzB3STNt?=
 =?utf-8?B?dXNoQ3VPYWt1M2c5RTd4b2p3bWkzWGJ0SVl6VDNQUmJ4L3VzVk9tOTcyTTZi?=
 =?utf-8?B?MXlsM0FTV3pHZHNJd2JBRk1hZGlEYlNjTWdMSElqaXNkaFF6VEdpc3ZLa1pC?=
 =?utf-8?B?bDJyZGE3L3h1SzJXVWZZRWwwWEh1WVYxeS9QbndEVkVOSWxjNVE3RWIwaXh1?=
 =?utf-8?B?VU56dUpoS2d0SUU1c09TN080UlVvbDNvWlFERWRSU0NNZGNFcGZiWTJmeHNX?=
 =?utf-8?B?WkwrbEl5Qkt2SDgvQkZNbXBYOVJycWFrL1JHMkRWd1lMSS9CU3RWSU8wUVE5?=
 =?utf-8?B?WTdFZ3I2Nk1LSFlRT3BlcFNyNkljYm92MWxCT3dHQlBUOGlwTkJLWm9EdkhP?=
 =?utf-8?B?a1QwRi9Bb2RFTkF5QnJ4MFNDekltSTRscUprcExtUDZzN0FKRFpGUU5uODc2?=
 =?utf-8?B?N0hmWVlndGVMTVA3RnNEWkJobmhhQ0NhWklBYlRJcmV6MU9iV1d5RkFRQWhV?=
 =?utf-8?B?SnFrOFlpbDBobktCc3JxcWhYRXNXaHBBZmVZNmZuK0tPWm5ib0JqWStHU2ZF?=
 =?utf-8?B?N1hLSVJVZnl0ZlVzRHpFV003RjRJZklROGhPdkU1VXR4MmdwWEpBNUpsbDMw?=
 =?utf-8?B?cXFWMlJqVWxucmhJcWpRc2U2UHd2emcra1VGNWdtMFBHS2NnUEEzS0toRVAx?=
 =?utf-8?B?WkdoakI1S3IxcnEyelhTV0dYYm83ajRCZjRmTFlWK3Jka1cvMm5qa2JYaGgy?=
 =?utf-8?B?cllsUzlDclBlbUFRenVtU1A3L3ovR3dZY2M5QysvblFMbUdSWW9aRGpvZjhV?=
 =?utf-8?B?QUI2YTJ1LzVaL3VaYVBzaVdxbGQxeEhBUzJIU1pTenhsZmU3M00zOWZ0SVIr?=
 =?utf-8?B?QUR0SHk2S1REd1hDcUpJOXFEVnRMUkU4OFgvVHZ4a29OT1hBNk1sTDM2a1d3?=
 =?utf-8?B?WHFOVDB3RXlmQmh2VjRHU280Z1g1cjdQZks1STVLa3djMGhSNnY3bHArbVNx?=
 =?utf-8?B?a2szNjJXQjNyK295THNVV2JaMHR0N2gvdXRyZjQwbll4U0svVExSN2JUbHZS?=
 =?utf-8?B?MVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AF0F977E82E12C4983DAABC240C8BAB6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c2217b2-0989-4218-eac1-08da94a5b21b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 10:01:00.4722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MHN95zf3VYrXKZpkWKxFMNV/53G03JH9rn8vH9aNs7V6oxBKBSKRgN8vNOMwKb7RMyyqyoV9uTF+Stu5UE5OVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4805
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gRnJpLCAyMDIyLTA5LTA5IGF0IDIwOjUwICswODAwLCBaaGlxdWFuIExpIHdyb3RlOg0KPiBG
dXJ0aGVybW9yZSwgSSB3b3VsZCBsaWtlIHRvIGFkZCB5b3VyIOKAnEFja2VkLWJ54oCdIHRvIHRo
aXMgcGF0Y2gsIGlzIHRoYXQNCj4gT0sgZm9yIHlvdT8NCg0KWWVzOg0KDQpBY2tlZC1ieTogS2Fp
IEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KDQotLSANClRoYW5rcywNCi1LYWkNCg0KDQo=
