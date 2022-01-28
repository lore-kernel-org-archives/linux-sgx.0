Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF01CC433F5
	for <linux-sgx@archiver.kernel.org>; Fri, 28 Jan 2022 01:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344808AbiA1Ba7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Jan 2022 20:30:59 -0500
Received: from mail-eus2azon11020026.outbound.protection.outlook.com ([52.101.56.26]:57122
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236055AbiA1Ba6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 27 Jan 2022 20:30:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dq2z2TB+qjJs3fP56zFp4VAQlsdmLIEhrU8NUIFQUQTmxeCQ2lEhFOApm6Q+tsFiRq6uD21kul+/8QNnWfTTQdyeN5dWKZS7ycB/waKJ1yq0Ef9O8iTrDexP0ZMbCLcCx+Jdc220ZAvtgQ0XECCGym2CRFeRD+ACioTDRVPF9TIn0B9TBIWZHaHSqEJ0Uhe0Dk1NvmRd7hPbpFM2t0rB7ehYgpPBB/lctZBaE/s6Q1GRNazaTSXYTJalvxtBQ9f9Y5KtV2j0U0ZeKvyuTyvqaTAVaYu5Lr6HFR5oC5830nMkeIDQN05eCv19iha92aIe/huh8TrORU3nBlZJFgQa3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZSI5kbaFDS3qQyRdjBIVBp87/rFIRadtsQRJml338sw=;
 b=FgVfW0075JhUfU5BYM8FsiRS5LyJbAcGbK3cme9JI5/xOJbLVZTyGgqr0umyqmx9bQh21T+howoHgn2RzIFXqd6LLRIN5iP9f+lBUGfY982sipU/T3juPlMmbYwxmE9UTkXvsDhqo2uDEkCx95ijpCznrjmZOpAY2NXz3AZlol1kKK5K8nZWJcMrYcIqSAjlJ+tN7tJlLCjyQYdCogn06l1ZFIHncKLXC1Tjg2A2jvcxDVjrG+pqPWuyOV9pB0sgvuui5T4uHDE0fg64eT95kg9c/SkFhj6u9Kz+VhhkA08wMtxiyHQVpK1ORws2k4Z7+zYeUvHl3VpagkyglY/E5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZSI5kbaFDS3qQyRdjBIVBp87/rFIRadtsQRJml338sw=;
 b=akumltgt3vUlfghTbBF0Hx6Lym3df0L5NdtLO6Jl6s4IH8dhkEtQysILE6EUNpMlawv7ourV9BWLCvX8yAfsTNFkYk53IsXTKmZdlXrxFFEgoyg4DUUbf2YLmzW1xF/tjLS8aaTGeheOr6kHifxl06gNvel43GQuheTEvVqKPT0=
Received: from DM5PR2101MB1080.namprd21.prod.outlook.com (2603:10b6:4:a2::14)
 by MW2PR2101MB1100.namprd21.prod.outlook.com (2603:10b6:302:a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.5; Fri, 28 Jan
 2022 01:30:49 +0000
Received: from DM5PR2101MB1080.namprd21.prod.outlook.com
 ([fe80::e19d:a025:5c34:dc1f]) by DM5PR2101MB1080.namprd21.prod.outlook.com
 ([fe80::e19d:a025:5c34:dc1f%5]) with mapi id 15.20.4930.002; Fri, 28 Jan 2022
 01:30:49 +0000
From:   Anand Krishnamoorthi <anakrish@microsoft.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] x86/sgx: Add accounting for tracking overcommit
Thread-Topic: Re: [PATCH v3 1/2] x86/sgx: Add accounting for tracking
 overcommit
Thread-Index: AdgT5goRrUm3pX5+QG+mFKVsbXdXLg==
Date:   Fri, 28 Jan 2022 01:30:49 +0000
Message-ID: <DM5PR2101MB108074567B5D75229FFA6D23C4229@DM5PR2101MB1080.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=268cc6c2-d934-48c2-9b8b-f6c256aad261;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-01-28T01:16:21Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 29eea606-085c-45f9-590e-08d9e1fdd095
x-ms-traffictypediagnostic: MW2PR2101MB1100:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <MW2PR2101MB1100C0468A08FBB23602EA66C4229@MW2PR2101MB1100.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bHS5jrcuALM4SM0isQSHJnowIXWprWIjd235a7uFpLpX8TQILBwLhyeCUACEsEoYNyQYe8tn9m4TIKtk76oqJuFPHjFwbxZO08K3ShOFy4D0Pgghaiah7RUb/191wynQPgo7GP+tAn0nItvogqT8SoKfB7Q/1+NhDYssaCNU2/8VJUdEAmQgHjQ8xmfSOzcn0qvCgM+OlnkfdBlHSMldIPM4BlhOfP9u/yVjqVTVaGMT7WcghY8kXsDrGmM8yfih+MJXxcZ6JarXfYUSL5R94mf70uWnJgAbBVl3hnDIo1oi9p8P8yiFJSvnfCnRswKDGxQForD9vD4uakCn8zPqKtCli1GE8EmHRpTcaMNWtpigf+IBXGJFY2CC9/BEvmE+PLcgWRydNKqfHEsP6Imt7oQtdAPphmWlGzU24OPvmNCY0dvEFcmcg14UbPCG4MP8+I6hvSnkiWA3ARuILbfM/VKVKJ5XJTiVMwdQ2ZzDkEAQnuBAwYGw6/aZPrie24tWvvLOepilL9EnsegB9ulzL1YPak5lkXsUuHTw/VA95/yD3ZgG7Tllx7WlMEoglm2qn8IgpF1RayCzsQahckHfmNN4UxnfdiyMBv/y4kbr4ctNa6elenk507E6+W6zUFwgUXxtdKRsoAmavAiVUrVwaSBrYSpuYT73lpLFYrcrBFF730MtEzwTObD3Gxcq2mek0i5HEaHTaypPVI1bwa0jGiv7CIWc9Qhtf9DKv8SejpT/lgmVdtaLd3+ivQVHAeBT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR2101MB1080.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(9686003)(5660300002)(10290500003)(52536014)(122000001)(55016003)(508600001)(2906002)(66556008)(71200400001)(66946007)(8990500004)(38100700002)(316002)(6916009)(66476007)(83380400001)(76116006)(86362001)(33656002)(8936002)(8676002)(66446008)(64756008)(7696005)(186003)(82960400001)(6506007)(26005)(558084003)(82950400001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?72PnRDfTAK7gAVh+9KEsZB1RjEHGqHi0iC58KVQJCcRMEBMyfeZkTB/f9L84?=
 =?us-ascii?Q?s9Q8e2YoZblRrwCfwoApX28Cf/jJ612ABzhBPDd5dhdpamcD/UlFHs5LbN17?=
 =?us-ascii?Q?g+WSsSWhxdlsIQifNMLD4qOupueyTqArX9QaHawZF2kPrvVujM+QOGPJw3dT?=
 =?us-ascii?Q?wdfLEPlW1FHKxGa6KCyKwWtRsgmj/zHVP4yZOaq/VUeaneWN/NhZ5HkCFb9F?=
 =?us-ascii?Q?1r42JXRoE6VGKAz/+DXC7eb1UV6sk6fLUVWZmpkvnDu+atWlV5W6wsr5okyn?=
 =?us-ascii?Q?fBkRzmQpMUCcqO688GC4jOp0tKZGb8kfJPQA0cXv/10KFbNwIY0vDTZhuuhK?=
 =?us-ascii?Q?wUwy4gXB3LnvJGRIn9uRrYdXb9FuXhurN/SNbIOYStT1acDtEcw2ywza7Hpq?=
 =?us-ascii?Q?qvEAheoHgD+LPHu+tyCKQNbT7QXbpKX65/EaiDMoMLaXiQR2Ao4DUa7jkjOU?=
 =?us-ascii?Q?GmeKrd7K6YB0wBTTI1zCv0duTnRr+WRdoS5hJqUIGOFlcIEKr95/4d2rEKL7?=
 =?us-ascii?Q?3JWS/f7JpwUEWGTtbvJGRXNuLTtOX78aHWUQUlfz+ByEE2tbUrRdg/iNVib3?=
 =?us-ascii?Q?v75q1qLZU5kOQjLkUxPXIACEPQdRZeunJoj2pCMlmv0QttsK2G74O3Z7E41n?=
 =?us-ascii?Q?MZK8wxUGGdcWnoSEWrMhDOOpMr7ioE6FAuL6JtNN0e7xwUdczzsxxu5xByoZ?=
 =?us-ascii?Q?7dbRYASz8fCemSqphGZOueJa4DRvbHp1/Jq1KGxPtbbK5gMwTeUGjsiD+qFi?=
 =?us-ascii?Q?8wg3P9gevv/SgMx0GTZMUrzgRzNBAJenxYX70HkhgDy/WQCCWE6cu7oOFGNw?=
 =?us-ascii?Q?A0kCvOCatnIQyJaa6fHRdWHhbeM3I5+rKnOAy5kH0azojFJmDKFe47vLJ0UP?=
 =?us-ascii?Q?fTlIDVo+KckUgUpCTjRfkEC98gEQiE6YyqEozLo0qvW40s5cGcEv/XtDJfVH?=
 =?us-ascii?Q?DzFq4We0kiRTMejznXSIOW1WBU3JWBFvKbVlzkY4/EkB4FKnvqS4Tt0aCRh9?=
 =?us-ascii?Q?lllmdwc3Jaj+9axhmBOJkep70JR8zOAefwFt91Ik6yZQHvGpC4II/7CfQL9f?=
 =?us-ascii?Q?bDrYPS0xGi6x7A6opJ6/kBppI3/kTp31jCmbPVzydlrOrHp4uIFLRpk3wOAH?=
 =?us-ascii?Q?d20ntNxU9bKJbLsF9uZS3E3Rfj3KULNbAFUnas6OzjuR51hAK9lJCi/JDWng?=
 =?us-ascii?Q?Vby4+6pq+T5fjFY0nH8nqFLbdRafPsizu+x1ZvCi2VFzjaL2WlZwTPX4/eXd?=
 =?us-ascii?Q?RBf3orA2fFoSqIyydzthnn5ZTJJjy0fbWz8pn7hNFgPIYmzkc1gSAy2/P9up?=
 =?us-ascii?Q?VXbFD4JEZ28JsgMaLbqYoWedA7/ol1jAZ98+r54DV2vefI2i0vqkUoG/VE7M?=
 =?us-ascii?Q?DZlotlyPTP1JsSKFqNdFVzyemjtqMbCjfNyg4924swupCjiCWXQxtArk7QQM?=
 =?us-ascii?Q?+oQXfoxNZHEQHoGseMc7fafa/MgHOKN7dFCuELwVpg9h9sF0tp9gIxwHqiaL?=
 =?us-ascii?Q?W9Ms0XSCd+mGws16fd0SytRw3q9AV/fbxIBDLsfGv+wng0Strwgc9y5SLGeB?=
 =?us-ascii?Q?6/bmcssjboAxwDab/YxFEoLgcDChGeYD8wAyrYe37U0ZoOvnWn7n7AE9HNVq?=
 =?us-ascii?Q?I1wvEnH3jOR/0fyi+Tz2U+E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR2101MB1080.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29eea606-085c-45f9-590e-08d9e1fdd095
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2022 01:30:49.0710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rjMW/Y4H6/Oo/TDbBPv9Hu1uUPK7Q0Rg++iHL0oNihBmkjdvxbx9Fdy3TJ2BvuEqv4+6qAvcTa4Ml8efJRMj/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1100
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Some of our users rely on EPC paging to run enclaves that require GBs of me=
mory on Coffee Lake VMs with less than 200MB EPC.
Would the 1.5x EPC backing pages limit prevent these users from running the=
ir enclaves?

- Anand
