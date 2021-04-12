Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB8CC433ED
	for <linux-sgx@archiver.kernel.org>; Mon, 12 Apr 2021 09:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1630D61379
	for <linux-sgx@archiver.kernel.org>; Mon, 12 Apr 2021 09:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239055AbhDLJCy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 12 Apr 2021 05:02:54 -0400
Received: from mail-mw2nam08on2116.outbound.protection.outlook.com ([40.107.101.116]:40672
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239518AbhDLJAX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 12 Apr 2021 05:00:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=djc6VdJ3upeiWAyXDrrcGMMoeEtQwiZ/PTVBG0ZZAgI7uwEHg2EJ1wv08Tz0fze0Vm8EOC1vQiftW4nNb1y6kpjDwCkqAe/4WYbLdHkrEy0dTOLqXOEEz920VqxauarLvOwVIViIi//Q2UfbyLoxVkqz+vuuWYsDtDdAELOdPdeAM0g5tk7+Xl8eToZKmvLKfCf1QS32FuMlCoO33wX14fINIybBfn2AsZ++lVNy5RrtdCjU20SzGUckFPOVayYphTfM/KH79bADNptgnzjmA0sOH3dK7/FPAanWTA52kSI2tCCwsYzrWUIUs7tuHQBpZ6v3IP7859yX05lItXWTgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EVSPR2JTl3t8G1eBm2Q7zlvRASyCH2iN+wcptp3nmrY=;
 b=NX9KH0RofwE9BLs6kQSpY6/FX4uS7GSKxiKvNd8jFjz9gy323/zS3Vly+vTCAe4I8hMSMMDU3deRDidewikVlGd/JGx5uaCvXB0PHNfIvrvRdXMD8MazuEnvDauR+U7U/oN7xeIVXLK7XzheQW24z18XRLujN2ma74b8M8/rcAXGY5LsUXpxEKoeg3v+b1iO8KE4W9dgCPZnO1wUccZxq1VhXQyjFn6ZjNAjrNT/MJMHBQhyRftHCvyKOWkTU2sk9H2/J/nqqfw52nRy0MNepm0m1VHAtIyH2DIBtvdSx6MViEqLciz1YtUefdL7FzP1Ve5y3aNm7TsFnC69MlYeqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EVSPR2JTl3t8G1eBm2Q7zlvRASyCH2iN+wcptp3nmrY=;
 b=BRix6E6vwV7PxvOXTRGaLUCRL3GCMzstleqUSCzOpjV/gyfClTmcd2PgU3Hdb+Ky+id2VlkA2u4dsbVXgO4k68k6ddJs8Ei0Rh7OzwhgnMGkQ5b9+XjTfCoYKgDwUESpktCD4b5kajpKemPMcODnEPKfuB5Ik+pCj81FAGZkQOw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from CY4PR11MB1783.namprd11.prod.outlook.com (2603:10b6:903:11d::20)
 by CY4PR11MB1782.namprd11.prod.outlook.com (2603:10b6:903:11a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 09:00:03 +0000
Received: from CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::f052:14fe:c2a9:5fb1]) by CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::f052:14fe:c2a9:5fb1%3]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 09:00:03 +0000
From:   Raoul Strackx <raoul.strackx@fortanix.com>
Subject: [PATCH v2 0/3] x86/sgx: eextend ioctl
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Autocrypt: addr=raoul.strackx@fortanix.com; keydata=
 LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCgptUUlOQkYyb2lmOEJFQURN
 UkFMT1ZjRkYyTlQva1FsWTBtVnN3YlMrYi9WNzR1azZFcDdxenpoNHpHbEtSS1pzClplS0I4
 WmpFT2h5Q2pZaExwdnJHTVh2cTV1bm5pWENIbG9BR1hZRm9rN0Q0SGd2Q0djYnlTYVRMQjds
 NHc4MFIKOStYUkp2SnJpMEdPSmVubjRnNUpIQU5RN2h5YWl5RlRIYTVERU5CMjc2VG9kZUFQ
 bnVidGl1VmRDT0lnQVJVbAp1dzJHemFsbmY0WmZ1TGdEaHg5YzIza2pjZTFBQkFWbWdxUEtN
 TkVUSnhyZFdLQUt5QkVIWGJ0Snh6YnR4bFI1CnFUZU8yTExCU2V4TFBDbTRZOTZzRHlGK3JJ
 a2FpRk5JQWk2b3RrTFBxYkROUlB4OTdLTTkzcmh5dVpIaWVQM1gKNWY5dG8vN0xEcGhqV0ds
 L0ZBcldmT2U1QTgxTnhoTG5GNm9kakMrN2JwakdkNXdvM2E5TTkya2wyelJ1bEhSUAoreFFY
 T2Z4NkNoNnBMSVkvbmRtSGZOVDA2ZTBCUkt1MlZxWEw4Y2Y1a2pkMW4waW1vU0FxOElGNmFq
 UThBdHl0CkR1T3JpTk82WGFQRVlqaHVvTzF5YnBFeDJCWE95N3J4aUN5WFlkSldJVmY3T29a
 c0xEM0wzTHBYM2Q4K1hZYXUKeWxab2dVaFErMHpoWlhBVnExSEkzc2duNnFIZ2RTT0J6aUJI
 cnhycGFvUnRhQkREL0I5WFhyM0FOTDhZWG9BegpISzJ4bDhhQTg1eWt0THlBNVc5WU1GS2Jj
 UXIrR1VuNStCNWRlOFN4SDgzTkR6TkljNnhtYUtKTU9xdGFiK2hHCmhRUEdtcDlmNDdGQmQ2
 QkhLYzFBSHJ2OElteDAyNVdYc1lBakpZbkVlMzI1dW5MeXlUTlB5VFo0NFFBUkFRQUIKdENw
 U1lXOTFiQ0JUZEhKaFkydDRJRHh5WVc5MWJDNXpkSEpoWTJ0NFFHWnZjblJoYm1sNExtTnZi
 VDZKQWp3RQpFd0VJQUNjRkFsMm9pZjhDR3lNRkNRbG1BWUFGQ3drSUJ3SUdGUWdKQ2dzQ0JC
 WUNBd0VDSGdFQ0Y0QUFDZ2tRCkFrY1ROU0RvS1ZoU1B3LzQ4T0FoUExHVndWSGtsSnE0QktK
 ckUrc0xTMjY4RnIyeEg5SlNaN3B5YU83bm5aYXcKcjNHL0dEVmN6L0FWZVZCQXY1OW8xMW9y
 TmFZdFAvUzdhOWFFbUl2bVZJZitvaW9ZaXh5eXlNZk9obFNmZnloagplWkg4ZC9OZDJTajJ3
 SXJ5S1BxNm9rYWY1N2pVR1dlbEFaNUZaUWJQNzFlU2E2dzNtcmQ5L1NOTFdFVTNPNWloCjRs
 em9HT1Fob2R6Qms2Yzh4UjZsQzJ3OHVyRkYrRnRhcmxwNkhxbWVBeHdXeHVQVDh4ZDhCMERl
 ODFFbjZIMFYKNjA0ekdsa0dYS1VTdXZJVHltdzEzYTJqYXQzTTRFTjNRb0lsbG5hN3N3ckly
 K3l4aTB3NzgvczZEU2dtVmFIZgozd0lncllMNDEwRnpCeVY1RzBDTlVuZ3lnL0d5ZWFiUVl0
 ZU04NHMwRXdMRFFkWSsrYXBZN1FYVEE1d1J6bFJNClRyc0s0MDBndlF5d2lPandST2x3U1oy
 L2QwSjBJdXNFdnpzQXIzbUNIQTRXWnNaeWpsT3Z1UXE4LzR0ekNKN1UKVTRvVUxMWll4ZkQ3
 Y1BVQXRTanBnNTFiVGhoai9nZXJDN1p4Sk1nSDM1MWR6RlowS2xsVUpHRU5QSmJkRFZ3WgpW
 c2lHRjdtcXVXVEwwQmpLYXl3ekgwZWdLVlh2ek56NXlrbjhJMDlTM3VvY09jSjU1bnNhR3pT
 WXlnZ3k3eGRoCitTMjVEVjMzWXNobU0vcGdXWW5IL3BUQzRDQUpmaGVpU0Yyd2EyR1g1bUZF
 QVBaQmh2Q0I2SzlXdkNKbEZXVzcKZTZ0dUpPRGdNUklQLzJ0SHJIMEFiMmFyVWJFWjhpaEdM
 L1pXcUIyRHlkeTJDVjU2ZjdjWVZBSndJTGtDRFFSZApxSW4vQVJBQXVEbXlwU3U1K3BFdlRt
 QzBBY2NUbVZnbm8xKzA0SllzckcvbVVuMG11cmFHM0xnZWtWMWVJWTVQCjVpYW05OEhiL2pI
 MU9kVXM5R1VCNCtLU1d4SnJERmNXNkZOcjJiZ1V1Y24wZm1XRHdOWU5oWGxJd0ZHMGRaV3MK
 SzNuRWlNSXJTTnhnSzBmS21jU2lpaTJhZlRMMkFTVm5JM09RcUN0RGhpU0VEWkJ3eW5BeDIx
 Nk4ydklNRFJVMQpiS05oVzRvNnk2R3BHNUdVQ2VBZnZ6SE5lMUNEbzQyQm5CRXUrVmlZYUE0
 cERrZ3hjaC8ydk5YQTBtc25rY1BiClJmcVlhOElpSVVTUG91WWVneHZ5dVJjbEhadFA3TW5n
 V2ZRSmxwQVlIOHdJWExUSTlScUpmTTM1K0xZRTNQR3kKS0RYZmE3MWFFUjkxcUJWMDQzMkNn
 KzFQN3pJUERTR0w2TEZJaFRBTE5TV05TRFU2NXpKWlNkY1NVQ21raytWZApqZkdGbk5LeEpW
 OGl2ckN2TGZMY2VpQWFWK2RHaGc0WkFWWStscVdFSGxYNW03V1JXQ1Jjb3pDNUd1TlVIeW90
 CngydVpHQys2TDVPTGVXeTZoUlhGSWdZWURLaWNnYTAzZjQ2WWorcDdKaTlWTGxvYWIyU0xO
 YlJFOERpK0xUWmQKempBMjQ4cDNTMDJpM1h5K3cxeGs4Q1VzOHVtMjlYNTVEaGtDSXdDdk5i
 Y3ZZcGtneTNjU3dZL2JmMm4xUnZ4aAo3MldxM2JBYXlVdC9yV0JFRTlTWkZ0cXRITUpCWVFX
 eDh3S244TVl5MU54YmpWZ0J0cVVaakdycW5OV3lnRStNCmFJZ3RpcUM4Q1VaU1c3dThMVW5a
 OUlaaGEzL2h1c0pJNXRmTHc5RmhTNXMvRzh6bWl3OEFFUUVBQVlrQ0pRUVkKQVFnQUR3VUNY
 YWlKL3dJYkRBVUpDV1lCZ0FBS0NSQUNSeE0xSU9ncFdHMlpELzQ1dFpmOFlvUkUxcHRQd3ov
 OQo5S3BIdFp5TUt5NFZLNmxXWDRCNnpHZ0hpcXpIQi9lekpwOEEzaitNc2FjM0hMZmtHdjVN
 UWYwRnNYUnBCZWhJClYrU0FBUmw3SktzM3pUck13TDU4QXpnNk5nbG5DZDNaYXQxU2hlWkhQ
 dVdXTUdCeERPMUg2UFI2NmRGWVJIM2MKODVaZHNHdWFobnJVSFBLemhZbWx4dUhDQ3FCZ3RK
 am9wS2NWVGsxRnRLVGUyZHJ3Z25Bb1M2dkh4bTdRTWxJVwpaMTluS25GOFAyN0pFanU0ckdX
 Z1h3NkgxSmFKMTF4YVVkZG9qdk53T1RKRVcvb3Jhd2tuUUF1ZW5EYnpBR1Z1CkdMV0w3T2ov
 RGZyTFBBemNXV25GblV2VVc2NEFEWFNBOTh0SWNBY3lod05uY2lqYnNIUkFTQlJidkg5RFhJ
 c2wKaEwxMDArdzZNTWNMeFpNVmJ4UHBTWWVHaGp4SjdNUysyeGp3eDB4MWlMNmszZk5UNHNT
 Q3dZa0xRZjJlKzhxYwpFYjNTa0Q0VFR3RDQxUW85SFNuUlkwdnRqblNyZkwyQ3JhVmptOXhh
 MXhmNlJDQ3kvaXpKNU5TQTZZMXduT0U3Ck1IOHorcVFUM1NxMld0a0NzU1M5K1U2VU9OWmFK
 dFN5MWNvZ1ZhMDV1QWdRY0tHT3FvcHg3QWlmZUhIUFpqZnIKakVNaHJZQ3Q5WXgzR1VET0hs
 MnRObDJIOStqZC9BVjByMDRKUTNxSHRWM1Z5UTNxN0N1UTlCTTdnQzVpK1JleQpHSU14Zm0v
 a09GWTRLRUxOeVYrV01PK2lXRHpZS21tTUxnUkVXNitqZk5jMzhrYWhaQjI2RmJOZTh6QmxU
 cVpPCmhxYmNZR1ZZNW9Ec004YSthbkwyZDhmaStnPT0KPW9ZT0QKLS0tLS1FTkQgUEdQIFBV
 QkxJQyBLRVkgQkxPQ0stLS0tLQo=
Message-ID: <da7ae1e7-59b8-63db-a9f1-607b4e529639@fortanix.com>
Date:   Mon, 12 Apr 2021 10:59:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.164.43.210]
X-ClientProxiedBy: AM0PR04CA0029.eurprd04.prod.outlook.com
 (2603:10a6:208:122::42) To CY4PR11MB1783.namprd11.prod.outlook.com
 (2603:10b6:903:11d::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (81.164.43.210) by AM0PR04CA0029.eurprd04.prod.outlook.com (2603:10a6:208:122::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 09:00:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd0c9b0a-f446-4628-f0ba-08d8fd915bf7
X-MS-TrafficTypeDiagnostic: CY4PR11MB1782:
X-Microsoft-Antispam-PRVS: <CY4PR11MB1782C9D57A9008307357F46E8B709@CY4PR11MB1782.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4qP5GB2fqb0ot3YDXjq1Vl2XUozbei2selT6LO3O4+cTY4n2FVOak36cobnp9660Xup2277O28uMGoAOg7Nq/DVq9bXex7N3H2dGZkxWfM1cgb+z9IKuImrwCn0uFikCKv1QPHudJcXu1pfiIToGbof71DxP7IC/qMsX4YE27NndQqefHFFtzIhOUdP/QcwIONLgMYyy7mRriAg36wcMWAFH3WcxToN36g0AquoYdlxaBPRilxj1nPICtSng1fPDNLdhK1bLWdMCjyylgYnF+g5Iqw61iKlw5wVvFUUnLTAueRiNa0mpj1Pv2sH8ZFfdsWWxT8275VIIV357xr6d5HxSLBouX9dLHwnIRA7oXPartbquNoBnAfIzSe9OZZReyVQzCnRETNMopQC29ihBH2Qhf4tIbD+cWLloQl2/5P8rdrpbQckloeAbWdSBim2Xw5NG5KQs59/2R+ymJhNeeYmMoEOG+RCDuA5zG4zmecIlT1h44izY9tIifWUmz0CNXB//gHqws5FJ7J0pc9wYa6fHnbGpd0lK+B9vG0qUIwUIDxB6LXgy53n1T/nQGEg9e3ngoSifvfqYtR/K2fn8WLvDOUDwPXRZwuITHFVaTMFbJIYVTXWWgqBVafnqQH/pWa+PzfJ1OMnbfyppM7TCdV7bzkXLzYNgRIt5ewkclRnsGXXzBdLhloKjWmqWBH4lDjvv1Kyuy8TyMuZZw2xBHLr40vE9HUhRpCPEKZ5t70+DOdCp/zfrA68irDlxu7b6q0txYWmavH+5skvLblMVk8J7dpuCXYb/Hp3ROjpTou0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1783.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(136003)(39830400003)(366004)(38100700002)(38350700002)(5660300002)(8936002)(8676002)(6486002)(16526019)(6666004)(2906002)(186003)(26005)(44832011)(66476007)(110136005)(16576012)(478600001)(52116002)(66556008)(31696002)(86362001)(66946007)(956004)(316002)(83380400001)(2616005)(36756003)(966005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VWppY1FMYXFDUXJlWHZZOWczeWF5LzY5OU5ldGdjUnBUc2pKNS9jdFVzdk51?=
 =?utf-8?B?R1ErR1ZUNHgwSVQ3ZjhUQjhjTHdwUkV3a09XaHlmNXlwSGplK25wREkyU3dY?=
 =?utf-8?B?U0NaREpPT1VteEVWbkZyeW9GQzA0MC90KzBXdmZGOVIrT0tmcm5ldFRiQlZk?=
 =?utf-8?B?ZXkzOHdWT0FIS040ekVWYVFGMkhWZ1pvZE5Sci90Q09ibmh2cVp4b05GNUpo?=
 =?utf-8?B?Zm9DM3B1T2lqOVZBaExWQkVEVUMzODNodTNOUENXZEtEMXVGWGhqSEJySEQr?=
 =?utf-8?B?Z2R0d3R6UEExWWg0b2hjdE92Y0JvZzRESGNXelVrME9MOFo4NmNySStjN29M?=
 =?utf-8?B?a2Zjb2lIKytydDBTYUhqVmtxTEJQby8wTWhUMUNVcUVPU0Jnd1dmWDdJM2ts?=
 =?utf-8?B?UjdDaGpGZUxpRU5MNEdYQXU2aUp5Z29RK1lQR3R1VlBUV2hsUU45anV5YUJs?=
 =?utf-8?B?SlRzQ20xWFVCVWJ6QmlHZkRsMllOMXZ2R0c2bHdBMjdzcEJlQW85T09qWm1W?=
 =?utf-8?B?NnloSHg2ZitHQjdkV3lDTmIvemNlM3VuQ0hCeWpKSk0vWXdlM2FIcEkvQkhG?=
 =?utf-8?B?Y1h1SDZNT21sdkEvblhwdjgrTnM0WTlRL3o1VUQvdXlFRldoNXVGK3dwbGdG?=
 =?utf-8?B?YUlNMXFybVI5OGdYM1htRUxuZEszSVBJT1RJekFvSHBOQWlVamFTY011dTlQ?=
 =?utf-8?B?djEydjJvKzF1ZzY3ODhGbXF5c1FBK0JnZy82RzgwZ0R1YWEwUENUd3hBVTNu?=
 =?utf-8?B?ck9tV3B3dUxpKzBvV1FXbWZEblp3U3JCQkQyWG52dHowNjI0Y1ZOTlp4L3JK?=
 =?utf-8?B?TzUrRkc1UkVuSEdCbmNWK1ZSR0hXN1pFZjF0NkV1eEJXRjhCQXFuN0E4a2M3?=
 =?utf-8?B?SEwvd2Vnb2ttWmkrQTRIVWl1cDRtTStDQU1wSmZOMXV6czkwdWdlcjRRRk1B?=
 =?utf-8?B?SWVPejh4YUUvQ09OaXo2aVZmVnVDdlRDV296MG9JVTlHSXJHNjJQOFhvZGVQ?=
 =?utf-8?B?ZmtwQUJ4eFp6VWdXVTB6SEtZT0JuN0hWSVBENjFKSmVzdEwwd2lKSUlzcm0z?=
 =?utf-8?B?TE1Ec2xmaytYRGpFWVdmQkxpcVY4eWEwVFJlOWwveXcxS2FyT3ZOaEtzOGxk?=
 =?utf-8?B?YmNZeXB6M0I0NXdVZTI4MG9QaU00UVI5THVXQ2o3ZlFFcVgwdEJJY3N4TDVt?=
 =?utf-8?B?Tkx4WEovS0J6UTJXajhmTm9EVVJvQUo3N0xDN3JidXVURXVBcGZYR2xQV2tr?=
 =?utf-8?B?VDVSYWNsRFRZTTE4T3AzT0NSQmxMdGhrSlphMTBUbTlJWHZFWVhRa0g2d0Fh?=
 =?utf-8?B?Rk4wdUhGK090WWZWL0ZvQkNMaXg0OUJxZ1haK3pFUTJ4aHpjdTRLN1VmWE43?=
 =?utf-8?B?UldTSzl5N0NMUjNMNWRYNEdSa2RZZytmanpkeWsvMDlESHdwQ2llQU4xUjJj?=
 =?utf-8?B?dnNCencybTBqR2xUdEVZaG16OG4rWGh3Q05MdlR5N2JmVTR0M1gzRFd4V2NC?=
 =?utf-8?B?bnQxbm5LcGdRbWRWSC9EbDBHbXJ4ZnJsaGdsNUZEWUFjY2tMdjBuT3B3enE1?=
 =?utf-8?B?YmRjNjFPRXFIOUkrekxWdlhpVXBPZlp2SXhzcjhUMWF0V09aUThyUG1NcG13?=
 =?utf-8?B?anc3VmhRS294eno2YUZBajhNNzB1bC9OQXBCQzFBOEt6azBpUTJQKzdIdzVt?=
 =?utf-8?B?MDYvNDllVWVvVmp3UjcwQkZzVDUvcHVxY01IcWtkeDU0YkVzcllJZ0oxOEtw?=
 =?utf-8?Q?J95Z15OQcor1WWmGv9rwa4FSnmvfya31/h8eZe4?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd0c9b0a-f446-4628-f0ba-08d8fd915bf7
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1783.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 09:00:03.1734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nQ3qJYGImkhvoq3HsGcHSm2r0BJNDdIRBAczng7E9AgMS0ZxAe5/BmJm4Rbe8DSEYSNDbUaOrCrRSwJ4gP6EuATzf7eYS5RugDjExTG1Xgk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1782
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Creation of an SGX enclave consists of three steps. First, a new enclave
environment is created by the ECREATE leaf function. Some enclave settings
are specified at this step by passing an SGX Enclave Control Structure
(SECS) that contains the enclave MRENCLAVE, MRSIGNER, etc. This
instruction also starts a cryptographic log of the enclave being built.
(This log should eventually result in the MRENCLAVE.) Second, pages are
added to the enclave. The EADD leaf function copies 4KB data to an empty
EPC page. The cryptographic log records (among other properties) the
location and access rights of the page being added. It _does not_ include
an entry of the page content. When the enclave writer wishes to ensure the
content of (a part of) the enclave page as well, she must use the EEXTEND
leaf function. Extending the enclave cryptographic log can only be done
per 256 bytes. Extending the log with a full 4K page thus requires 16
invocations of the EEXTEND leaf function. It is however up to the enclave
developer to decide if and how enclave memory is added to the 
cryptographic log. EEXTEND functions may be issued only for relevant parts
of an enclave page, may happen only after all pages have been added, and
so on. Finally, the enclave is finalized by the EINIT leaf function. Any
new invocations of the EADD or EEXTEND leaf functions will result in a
fault. With EINIT a number of checks are performed as well. The 
cryptographic hash of the final cryptographic log is compared to the
MRENCLAVE field of the SECS structure passed to the ECREATE leaf function
(see step one). The signature (MRSIGNER) over this MRENCLAVE is verified
as well. When all checks pass, the enclave loading is complete and it
enters the executable state.

The SGX driver currently only supports extending the cryptographic log as
part of the EADD leaf function and _must_ cover complete 4K pages.
Enclaves not constructed within these constraints, currently cannot be
loaded on the Linux platform. Trying to do so will result in a different
cryptographic log; the MRENCLAVE specified at enclave creation time will
not match the cryptographic log kept by the processor and EINIT will fail.
This poses practical problems:
- The current driver does not fully support all possible SGXv1 enclaves.
  It creates a separation between enclaves that run everywhere and
  enclaves that run everywhere, except on Linux. This includes enclaves
  already in use on other systems today.
- It limits optimizations loaders are able to perform. For example, by
  only measuring relevant parts of enclave pages, load time can be
  minimized.

This patch set adds a new ioctl to enable userspace to execute EEXTEND
leaf functions per 256 bytes of enclave memory. With this patch in place,
Linux will be able to build all valid SGXv1 enclaves.

See additional discussion at:
https://lore.kernel.org/linux-sgx/20200220221038.GA26618@linux.intel.com/
T/#m93597f53d354201e72e26d93a968f167fcdf5930


Raoul Strackx (3):
  x86/sgx: Adding eextend ioctl
  x86/sgx: Fix compatibility issue with OPENSSL < 1.1.0
  x86/sgx: eextend ioctl selftest

 arch/x86/include/uapi/asm/sgx.h         | 11 +++++
 arch/x86/kernel/cpu/sgx/ioctl.c         | 81 ++++++++++++++++++++++++++++-----
 tools/testing/selftests/sgx/defines.h   |  1 +
 tools/testing/selftests/sgx/load.c      | 57 +++++++++++++++++++----
 tools/testing/selftests/sgx/main.h      |  1 +
 tools/testing/selftests/sgx/sigstruct.c | 43 ++++++++---------
 6 files changed, 154 insertions(+), 40 deletions(-)

-- 
2.7.4

