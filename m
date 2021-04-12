Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A69FC433B4
	for <linux-sgx@archiver.kernel.org>; Mon, 12 Apr 2021 09:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 310B7613B1
	for <linux-sgx@archiver.kernel.org>; Mon, 12 Apr 2021 09:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239647AbhDLJH4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 12 Apr 2021 05:07:56 -0400
Received: from mail-bn7nam10on2137.outbound.protection.outlook.com ([40.107.92.137]:11584
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240380AbhDLJFw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 12 Apr 2021 05:05:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kNnIZFtZfAlmJwcY60gM5zGHEkdJgsMbPccWu5Ko/BdwbZxGRYyJkzu1Z+jVU4FvBws7zPanPLo0u8VHRXwVtvIxJIRIo+fAL2bFJn4gFbZenYqY8HZKp/xRp+5kkk0GL646NjUq0+h9oYDls7nGyYTTc6HeV+4JB1XRdjB3WpTgCz2Uqsr8Pyw2/h0+zdy5TJF3rjFXVETM4R50brLf5hnaKiyGNWrMgIa7z1dowYBLym2kbdg/90fNe2AETeWLrr15JgWpo6Hgdon5kRAYDM0tzGeGNusOk/PLqryjt6WHvuvJ0Z5UWSH1Hp5prKDXeZChU3IG4lHBZEqoFqn0rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJWBrtQh9aORyFSZJY28iwxDc+kXJPC8VEn56mdRRkA=;
 b=F2oe4qVRjDhg9Mwm3lYNdZnBkaywbln26AZOulJ4eKa+2atBZlIfo1S7pmfqR9pSLZ8ywp2+zZVqFkC9ujeDR7721EdRDuSGF5smbkrwA7oIi5noTQx7R5zHIgw633YbIoG0kcT2KvOr3swE1m8bl7k63kYpCQChTP8t3zEvWLBnljcEYfHURmxXQEM+XYPd7y130WNKGAnw9QVYeeLttk3ITA0YOZ28EzpaFkL7Ic7hL8va/vRU40Ogbd5+I8fg4xK9EAmkLATTwFSAtqBD3IwOjFg12cw4PneZcDBBCGQiEjv2lxCo88vQQn0ZI4SpMowHLdh74Tev8tII+p11Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJWBrtQh9aORyFSZJY28iwxDc+kXJPC8VEn56mdRRkA=;
 b=TD1Dev/03+19oKHqvjeDQ+bFNe4jiCyeZodB6mFcGeropcg6zNwvCE5iKgBCRFYHU1zFP0cByRiKVLnIqFQSt868229UjwrVjmWiQnfV+5eFXYVMAhKu5auIQfX+gegwR2z8OxzthPJFXWJ6TimOlidBitkpR4iE7oOdXBZSaSA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from CY4PR11MB1783.namprd11.prod.outlook.com (2603:10b6:903:11d::20)
 by CY4PR11MB1384.namprd11.prod.outlook.com (2603:10b6:903:2c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 09:05:01 +0000
Received: from CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::f052:14fe:c2a9:5fb1]) by CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::f052:14fe:c2a9:5fb1%3]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 09:05:01 +0000
From:   Raoul Strackx <raoul.strackx@fortanix.com>
Subject: [PATCH v2 2/3] x86/sgx: Fix compatibility issue with OPENSSL < 1.1.0
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
References: <da7ae1e7-59b8-63db-a9f1-607b4e529639@fortanix.com>
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
Message-ID: <92282c72-5849-70d0-1553-548130fba2bd@fortanix.com>
Date:   Mon, 12 Apr 2021 11:04:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <da7ae1e7-59b8-63db-a9f1-607b4e529639@fortanix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.164.43.210]
X-ClientProxiedBy: AM0PR10CA0040.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::20) To CY4PR11MB1783.namprd11.prod.outlook.com
 (2603:10b6:903:11d::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (81.164.43.210) by AM0PR10CA0040.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 09:04:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e93b891-217c-4247-3132-08d8fd920de4
X-MS-TrafficTypeDiagnostic: CY4PR11MB1384:
X-Microsoft-Antispam-PRVS: <CY4PR11MB1384A3F903F5F34AA2AFEE748B709@CY4PR11MB1384.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RUcQfen7JDgN1mrV4c2OmpZsU06JmgAqSlR8Yw6jEG0919kNgCHeXsmWdCk2gqLZfPDmAGhPxJXTB43k2E/mfKcNwM616fio4Le5ySrodKaPHaP6W3cuAdOP3HT/Ql0FZ8v7RMXbQn2fbd5uLI4/FpOit18IB8HZrDV8zzZSdouQiHQmtf0QI0BgJDnx6KsTvw9CKYmgOc+jFxtoNLL4reEBk9s96uNtH+B15hq6NClrR/OZit4ksNWMiF7gjjSnWq3mqViV0IVhd5Pw++pzTUzZwAzO5cPYvBjEikp5ygGH/M6aitvq2R9z5ZPn00ClUc2baykTDCIAGhS4Gt7QOL5gn16uTXQhD3xlPRkg+fYf8R7S+BsQFAb3/y9715v+Sj80NpMOZNjkjVcId+dnvUVfphUwRSFKwEN1TI9HkgIC71N9QNduu2mkTXsR5uZ/ca0dxYcxOZR7TRqcGVHYjoonNIA0QJtfmYWiCkO98CYfkwC47cw8tg7hXj1PQ2+WsCQ5iLC+xgOMnbrT3JzFc2psM5ZWebxvamuZYo/6g7RrG8TjxcLeXITz5xxpomkBGZoRRNZh2BHvpZLwd+NWEgyqajoRwGm0TX+w5xPGfjDVeeDUD0gVYtAkgo1oH+/Somt6z2+bvInXKB9pIkg/KDz2XyRRLJvcXCA8iYlgqyB12DeCr0sPcTMRRur6FPPbnUa3wHI16HEJ34geitNf8OnAu28RpZ+kJfrgQG4MPKw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1783.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39830400003)(376002)(136003)(396003)(366004)(26005)(66476007)(4744005)(6486002)(186003)(16526019)(66556008)(44832011)(5660300002)(2616005)(38350700002)(316002)(86362001)(6666004)(956004)(66946007)(52116002)(31686004)(8936002)(8676002)(110136005)(36756003)(16576012)(2906002)(83380400001)(478600001)(38100700002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bTRHUmh4RksxZ3JvTTF5UGRlendVWjZobE5CTW9lU1cyMzZBYzB1UTdyUFhi?=
 =?utf-8?B?dlVaUU0xcjNQcUFKRWJhR1RmUzFaMnlpaWVVKzBORW13aWNGM2FyQW5tOHYz?=
 =?utf-8?B?aFNYVGhocmFrZVZUYUZVYWNzN3Z4TURndzlkZ0Z1WjZUVHI2OUxvaXVlaHRX?=
 =?utf-8?B?TExaalZsUFlQekJNajNVa0w5TUpxRGV2N1djaVg4c0pWaldjNFBGbEdRb0dh?=
 =?utf-8?B?Y1g5U1l0TFJtalB2M1BCYVBQM3p4dkhTWmVWT0lHYk9waWxVcmZ2dCsvamVr?=
 =?utf-8?B?eFBvNUpRS0FKU0JXZ0ZEOGs0c1hqdUFOUXQzdkFZWnQ5ZlBmeHBmNUVUUHJJ?=
 =?utf-8?B?U1F5UFNLS09Ob3VOcy9FVUFaQXdEQ3A4VDZ2bmhlc1AxQUs4MkQ2OFF2M3JB?=
 =?utf-8?B?WGxnazQyZWphOUl5SmJHL09TR2JmS3pqUU15ZWw3L2xGRlgxVEx5K0dCOVda?=
 =?utf-8?B?WGN3dGdMWnNLQXRKZ3ZRV3pjSC8wUkdaN3FaRlVWM3ErRzJBYTV3RmthNzNN?=
 =?utf-8?B?dkNHbFdWU293a1VZVytZLzRPcDFsVzl5elhFR09UOFNGaE0xUE5CdXk1QTJk?=
 =?utf-8?B?T2tmQmRuMUs2WlVZSXNvN1lVM2FYSHJySlRDK1VpUmZvcXZqWjBJTFhTampW?=
 =?utf-8?B?UUZTMVlyUXBrYThwdDNtZk9pL29jOXc4Q2R5NlI0R2hDY0JUR1J5cTZwYytH?=
 =?utf-8?B?MjIxMTc0SWFwWUZBd1Z5c1RySXlUY0J6dXRhWnh6c2dDblBDaE9QWjNZMjBV?=
 =?utf-8?B?SEQ5TjdCZUJqU1dTU1gvcExWdGU3RUZHZkJKYXhFVUIwTDBQdVk2c0kvYnBT?=
 =?utf-8?B?ZHZha3VDUE9ZS21lbGh6UUFMVW1oWmVKN3lhMW9rb21JcDJqR00wU2NtZ0w3?=
 =?utf-8?B?aHBQeW0xY1RXWWh0TjNzUDU0M2l3TVlKWTlsQ2lFTHE5ZDlLSUhBQzM5NFZR?=
 =?utf-8?B?QmJpdVlkVXJaZEZKcmpJUDg1RUYwNkNhNFhBcEc2ek4vYkZFdWpFRUpzWFBo?=
 =?utf-8?B?bW8vL2U0TWd0Vnd3RjVOQk1XMktWU1ZncTJIT3UzOStJRWRickUyRFdGZE5w?=
 =?utf-8?B?clgrVkpmcFczdGdMSTRqZi9VL0c2b2hvWDAvNVdsRU9QcjY0WU9zZFlLZi95?=
 =?utf-8?B?ZFZZZVVCeVdrWXZ4Z3Y4N0ZxQ0JRS1FENmltb3BVWnlHOTZnZDBVaDE1cEVW?=
 =?utf-8?B?aS9XM2duV0xqaWZWMzRTWHFXOEVzWU1IUGd6NS9La1RrNFdTY3ZVdEV5ZU5z?=
 =?utf-8?B?YW1rZndESi8vT3ZnQnFBS1lqZHFDVCtETCtFTnUrTU5ISXZHZ0pTaGx0ankz?=
 =?utf-8?B?cWZJeEJ1MkM5bnpQb1JUdGNzSE9ONTdQekxKRXE3S0hWcDhqZ1hrSittWlhI?=
 =?utf-8?B?UEozaTRzOWtKeXRSTUZRbUpud3ErWmJPUFlGem5PM08vK0xXTlB6VkptbDlZ?=
 =?utf-8?B?KzlOTkgzUkZSaHplWW8xTmIxdzdqYUJob0hkSVRhL0h3T2VVWlYyblhNUnNO?=
 =?utf-8?B?V1Q2RlpDVUNzOWlNT2tpWmZtU0l2MlMvcnVXZElpSTlWLzNheThjaWpUMStY?=
 =?utf-8?B?NUxxODZPbTJ4TVBhdm05RkJUZm5UbWt4UDBnVzRwZ25WVkw2dXdjVWFCVzd5?=
 =?utf-8?B?eFRxbG9rZFpGTm8rS3FKc3Qrc2lzbk9NaEhLbUp3dzNLU3d4bmh2bGNRK0Vx?=
 =?utf-8?B?cGRCQXNtK05jVm91K1NwK0t6OWNEL0ZoUFRJVDVRcXhQbU5PWkVlVHUxTHp0?=
 =?utf-8?Q?sjHdkXUhmhQtHNQmosK8y0Ba+d1Fip6MfvM3bFj?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e93b891-217c-4247-3132-08d8fd920de4
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1783.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 09:05:01.4995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lLpcjU9NpimaF4e0jb4yQWYBwCay6QHYjbGKeW2Fve0mnhoJ9hYKwKMc5KHDP52L4SaNw1JytSiT2i7f2FqqEnODusFE4g7br2VCNvYusOM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1384
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The `RSA_get0_key` function only got introduced in OpenSSL 1.1.0. This
makes compilation fail with older versions.

Signed-off-by: Raoul Strackx <raoul.strackx@fortanix.com>
---
 tools/testing/selftests/sgx/sigstruct.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/sgx/sigstruct.c b/tools/testing/selftests/sgx/sigstruct.c
index dee7a3d..aac9cbc 100644
--- a/tools/testing/selftests/sgx/sigstruct.c
+++ b/tools/testing/selftests/sgx/sigstruct.c
@@ -128,8 +128,11 @@ static bool check_crypto_errors(void)
 static inline const BIGNUM *get_modulus(RSA *key)
 {
 	const BIGNUM *n;
-
+#if OPENSSL_VERSION_NUMBER >= 0x10100000L
 	RSA_get0_key(key, &n, NULL, NULL);
+#else
+	n = key->n;
+#endif
 	return n;
 }
 
-- 
2.7.4

