Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1350FC43460
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Mar 2021 12:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE8EA6196C
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Mar 2021 12:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235684AbhCaMwC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 31 Mar 2021 08:52:02 -0400
Received: from mail-dm6nam10on2125.outbound.protection.outlook.com ([40.107.93.125]:11104
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235654AbhCaMvj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 31 Mar 2021 08:51:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kiruU7Kq/iL+yBAYRKYdPdTPYiNLJci/nURezYv52JWX4U36MoiagiFUfgR1hxAoypdClwTM2CzV6d/QNShax4GDxSbhHVRr2ocy5ilWL1gsh55Y3iYqpWjjIupJgTp1jib+VUYfUx/7Nkw9uXIQVi+G/qptzydZimU7umAvboQFzMpltGqlNHLeGLVojeWQ68v3kuLYPhfKtGE8Fhw1yTxEGAy225xdVw5n/9Umro8GQ7Nli7gf5ndjq9o4FdB767gJsGiWU54fBORyYYGTUmdDqdpcN7+NsVag3xSXX3qc3zDlXrE3eSwNKVHXFA6JefZXJikYCuLL6dUQ/2J0cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sn0/WsafaTrgS1iuYWiKLeoO90R7Il7zyL18dwiDe8Y=;
 b=Lxni+w3FSdQEI/qFINwUWnvCP+xS2niyGA4xJDEqkuFUmPNDrCvNOALhL2Uc/lrVKza4fFkp1Jd22qYuEQpvq6LnCgOtyZ73SlCRWlBRT0dw70sApZzWOCh+sUh3vixVaOUNXAJI0SnLyWj5WvNEdcfoE2A1dy3h2maTvhpjXLgzoc4hup2gjtmEE9N9tfWE179sQtW2x8n/ESH+uC1shpF14T8Xfm3FKabZDzHiAwT590BZjkCMJEA4yG2XO1/Kz6dYfXsIwN2dgcqYiCxBBhIsd7GFGVCvGrPhxeQcGiAojcW/TiXaBnZEQZ8+JOa3lFFOIg/ChgbiOV75ZaYduw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sn0/WsafaTrgS1iuYWiKLeoO90R7Il7zyL18dwiDe8Y=;
 b=hMvkX0GnrwiTaL1ZzGdezuXcfAr2jyT7cjzbOGvzcXjasDoKYiTlOQfA8qoCmp+yLVx05OQ2OYf/gkUDpZMJx7T0ciePSTqEh42hypYpbwkpC4P8R88USpiwt3QSsQVxAcWkc12TKoCAHRESTPIOYP1ZdX1Zby46XJQ72Fp7ETI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from CY4PR11MB1783.namprd11.prod.outlook.com (2603:10b6:903:11d::20)
 by CY4PR11MB1958.namprd11.prod.outlook.com (2603:10b6:903:126::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Wed, 31 Mar
 2021 12:51:35 +0000
Received: from CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::6dcc:f099:6ba8:6ebe]) by CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::6dcc:f099:6ba8:6ebe%10]) with mapi id 15.20.3977.035; Wed, 31 Mar
 2021 12:51:35 +0000
From:   Raoul Strackx <raoul.strackx@fortanix.com>
Subject: [PATCH RESEND 3/3] x86/sgx: eextend ioctl selftest
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1617194795.git.raoul.strackx@fortanix.com>
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
Message-ID: <dc3a1064-1527-eaa9-6c4d-1599fee1458d@fortanix.com>
Date:   Wed, 31 Mar 2021 14:51:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <cover.1617194795.git.raoul.strackx@fortanix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.164.43.210]
X-ClientProxiedBy: PR3P189CA0050.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::25) To CY4PR11MB1783.namprd11.prod.outlook.com
 (2603:10b6:903:11d::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (81.164.43.210) by PR3P189CA0050.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:53::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Wed, 31 Mar 2021 12:51:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c8c48e2-1171-4e11-c966-08d8f443b7cf
X-MS-TrafficTypeDiagnostic: CY4PR11MB1958:
X-Microsoft-Antispam-PRVS: <CY4PR11MB195809CA572B7FB25D2054A78B7C9@CY4PR11MB1958.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ueCm6BK5+Aj3+lsDDXHY2fhfNm+w13yr6kuG7h9Gw9wZp0x/IeLSkzY5eXgDSI+ORpxKcOh35kMtEYJit4xy1Fibj+3DANVGmSnFH9ceQMpbKSLbgr0RY0MOyOSTBIDJJSFCmKBSqkAI+hGpVHgWj4fSlvYRayl4UEU5+lo7FGJWz9zpWru4R8/tri4MhJGRWuUfhXIm+fLEZJtdNSWPHx24z+LP0T/eovrGKJx8jLjdKUPPgXOOeeFzgi5lBMEJv/4F4IrXkXLQNPJUJS3s/tIKfqZW+aEaiRtZpQvsuo9fJdcSVxNB0uqiIxeyqduZ9sBpKR6Su7JheEopqVh3l8xIvvBDT4gnL7VoOwQ7OgBS4qS6k7UWKIGmdxnE/X2ihJZquH/MHusNNQsLWfBb3bSVaFg9lPMgTXElXMz3UON7Vx4BFXtEsjy7DfggDBg1B/BElTMy1Qr3WEao3J4e97GR7ln80l+rkcWTB54pv1PfKrlZaNhYnqAfIfFgJWXFgVwjSg1tJvnjLUkk2X5pGegRr8NXjk14RIadg1Nu+Ph0ZW5EEC+fSesZIlRinuYpWwKDRTIMFL5IYFkJSEiluBDkBObdbM+3d13+fT/VwrX9WWna/GvQqUb+mcYR3AAVuRXQh1AStuJsfBNvLoIM3MlyrbAJ6819W8wosp2khnk4WV8xDUBveQculOzinfJCedrWW6LUj/tuwBmI3wOxV+Gkp3DwMyyY9h/JUuvxvpA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1783.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(39840400004)(376002)(136003)(6486002)(110136005)(956004)(2906002)(2616005)(8676002)(31696002)(31686004)(5660300002)(44832011)(52116002)(66476007)(66946007)(66556008)(478600001)(86362001)(83380400001)(36756003)(38100700001)(186003)(16526019)(6666004)(316002)(16576012)(26005)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZVEwdFFUNTB3Q1NhMFZmejJob29iSkxHS0RBdFZSdGRlVFI1VzYrVmdMd01C?=
 =?utf-8?B?aVpDa0ZLV3FIamFpUDROVkNIQks5NGlPNWVEY3NVbVJOK3EzMzl3M2xaazcv?=
 =?utf-8?B?S2xuRW5KVS9JR3BGSVZoSk9aUVpyTWJTZGQvbFAxcjFOa084VmU3blU0V1h2?=
 =?utf-8?B?MmhlVDFFMUhKYzNqYWJJNHlVWkVmcGV5UXRFYWlCb0R0K2RMT3hBdVR2ckc0?=
 =?utf-8?B?SXRlWUJXek1FTC84R2xCYzVGUitGT2NHSUV6MFgybEM3bzRxWGtOMlZ0a2FE?=
 =?utf-8?B?azQzdnNMN2d6MEpjTDRQRzcwVFpLUHM1dFB2ZzQrRzZsRU5GL0F1SWJ0SGh6?=
 =?utf-8?B?RTRWNEFWSnNUV1FxREJzVnRJeTI3bXNvOUlIaHkySWQycWlGSGZkS1pkK0c0?=
 =?utf-8?B?aDh4Q0xYdjFLbnVkUmZhN0dSVHZsSS9YaFRWRGk5M21TdHBFSnZQWnpNRDIr?=
 =?utf-8?B?OE1nTmVPQ0ViN2QwVjRHbWRSZHhRZlJ3KysrZnFXWGY2QlFHSVBvVW92Y0hn?=
 =?utf-8?B?dkRpUEpocExkK3c3eTg2c2hLWFY3WWQ2SHJGY2Nzd1FrYTRZaFU0S3l1TXBX?=
 =?utf-8?B?dkpObUVpR1Bwa0NFcGVSMFZNRlFjMk5sdHVzZWt4cGlIZitmc3FiQVA3ZEgx?=
 =?utf-8?B?L1NnZVh0Y2R0a3pIQ210UW9WcGdaK1N5MFlkUG9YYVBJN2dNWFZOUE52OHhl?=
 =?utf-8?B?R2ZNNzFTODRqSHd0a1RtbEhFM2RVcjUwYmRnbXVvSXJaeGZwOU1OU3lFWGtk?=
 =?utf-8?B?R25abDFVdDIveElJcHRSQmd5TUZrSlpaN0Y4T1I2bFVQM1krUGd4c25PVDRU?=
 =?utf-8?B?VkhyT25LQUdGTnBaVG5zbG5aUEhHcXFadXRIaFRxY3owRmFHWnY3cFdXNklw?=
 =?utf-8?B?aU5uUjJsd0J5SDc4QVh1ZUdDZEpienZGUGdHMGc5QVliR3V3M1gxenZMNjIx?=
 =?utf-8?B?NnpxdFR2dVRiNFlNNm1POElzd29MZUxYWkJXVFFUYi9qRGdwU3FtTGYySzJi?=
 =?utf-8?B?SDNNRlBRUFMwenRWQ0NMV3Q2UVRzWTN4aFhRcVhsZ1ZZZmpxMWJCdGNaTU53?=
 =?utf-8?B?SkR0QTlETmtXQ0NPOVlYdlBvZXdGbjY2MVdTQnkzcVdaYXhwRDgxSnFPUENH?=
 =?utf-8?B?c3JTRUJka0NZMFlLL0NaMmhyMTRTeCs0WnpvbHZPenVuTnFkNUFwdy9Tc3Jh?=
 =?utf-8?B?L1ZMb1dmdkJoR1hXc012UkpmZ2NSRnkyVlZ0RXdpbUdyOVIzbm8vOHBqUTMv?=
 =?utf-8?B?VGtwajRGN1p2SzJjWVFGVG5YTCtQTk1IMzQzS29JUlJteGFlUUFKSll1cU5m?=
 =?utf-8?B?NUVNWU5ieXJLZ0FjVGsvbVliM0ZMdDBsL3p0b1JhV1IvMi9qOGF4VXhGUFN3?=
 =?utf-8?B?T21KSldmU3ZvVkFpdEJkVDFnSlhVQ1pLb2FZT2NLekh5QnltN1U1UGJqcXJN?=
 =?utf-8?B?WHJLVUNqY2Rmb3J2aDVCTm5vL29DYUtTMXpSaTQ5ek5kL0g0b1AwaFRyOEI2?=
 =?utf-8?B?NWtWS1FTVzhiTVdaaEsyQXc2QkgvN2RMaUxhcDlreG5WS1ArdHI2NjNuWk5L?=
 =?utf-8?B?VUtYc2xQNWJMZ2F4YjRCZFJ4b2U1VnMwOXl4QXllMStvK2p4QU5NckxiaW5F?=
 =?utf-8?B?SkZIM2l2NmdtZVJEbmQ5a2dlL0FtTGFwMXo0dWdjWGFEaWJFd3JXeDk3QklP?=
 =?utf-8?B?UTRTSTFZdnN4YzBMdlEzaDIycnh4MmhucDlTUFR5L3B1R0RFcm1WMTdwZmVz?=
 =?utf-8?Q?Yuhimkz5jxJWQlw7Ips1mxqVu9aAtgrn0ynC0q8?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c8c48e2-1171-4e11-c966-08d8f443b7cf
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1783.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 12:51:35.7808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RxVyaoyoLLqgvSBLhWevxWFLH9SE/4v0zEAV7+7TtbbF+OpkWqjGH7ck7Iz66RtdKMaGLRKavxRqi3C0cuBgL7JJ7o8rPWBBRzcMIu/mWSU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1958
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

In order to test the new eextend ioctl, the SGX selftest is modified to only partially measure the last page of segments. Most segments are larger than 4k, so the MEASURE flag for SGX_IOC_ENCLAVE_ADD_PAGE is still being tested.

Signed-off-by: Raoul Strackx <raoul.strackx@fortanix.com>
---
 tools/testing/selftests/sgx/defines.h   |  1 +
 tools/testing/selftests/sgx/load.c      | 55 ++++++++++++++++++++++++++++-----
 tools/testing/selftests/sgx/main.h      |  1 +
 tools/testing/selftests/sgx/sigstruct.c | 38 +++++++++++------------
 4 files changed, 67 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/sgx/defines.h b/tools/testing/selftests/sgx/defines.h
index 592c1cc..c09550d 100644
--- a/tools/testing/selftests/sgx/defines.h
+++ b/tools/testing/selftests/sgx/defines.h
@@ -10,6 +10,7 @@
 
 #define PAGE_SIZE 4096
 #define PAGE_MASK (~(PAGE_SIZE - 1))
+#define SGX_EEXTEND_BLOCK_SIZE 256
 
 #define __aligned(x) __attribute__((__aligned__(x)))
 #define __packed __attribute__((packed))
diff --git a/tools/testing/selftests/sgx/load.c b/tools/testing/selftests/sgx/load.c
index 9d43b75..52f0569 100644
--- a/tools/testing/selftests/sgx/load.c
+++ b/tools/testing/selftests/sgx/load.c
@@ -102,28 +102,67 @@ static bool encl_ioc_create(struct encl *encl)
 static bool encl_ioc_add_pages(struct encl *encl, struct encl_segment *seg)
 {
 	struct sgx_enclave_add_pages ioc;
+	struct sgx_enclave_extend ioc_extend;
 	struct sgx_secinfo secinfo;
+	uint64_t size_full_pages;
+	uint64_t size;
+	uint64_t chunk_offset;
 	int rc;
 
+	size_full_pages = size_fit(seg->size, SGX_EEXTEND_BLOCK_SIZE) & PAGE_MASK;
+	size = size_fit(seg->size, SGX_EEXTEND_BLOCK_SIZE);
+
 	memset(&secinfo, 0, sizeof(secinfo));
 	secinfo.flags = seg->flags;
 
+	// Add and extend full pages
 	ioc.src = (uint64_t)encl->src + seg->offset;
 	ioc.offset = seg->offset;
-	ioc.length = seg->size;
 	ioc.secinfo = (unsigned long)&secinfo;
+	ioc.length = size_full_pages;
 	ioc.flags = SGX_PAGE_MEASURE;
 
-	rc = ioctl(encl->fd, SGX_IOC_ENCLAVE_ADD_PAGES, &ioc);
-	if (rc < 0) {
-		fprintf(stderr, "SGX_IOC_ENCLAVE_ADD_PAGES failed: errno=%d.\n",
-			errno);
-		return false;
+	if (0 < ioc.length) {
+		rc = ioctl(encl->fd, SGX_IOC_ENCLAVE_ADD_PAGES, &ioc);
+		if (rc < 0) {
+			fprintf(stderr, "SGX_IOC_ENCLAVE_ADD_PAGES failed: errno=%d.\n",
+				errno);
+			return false;
+		}
+	}
+
+	if (size_full_pages < size) {
+		// Add last, partly measured page
+		ioc.offset = seg->offset + size_full_pages;
+		ioc.length = 0x1000;
+		ioc.flags = 0;
+
+		rc = ioctl(encl->fd, SGX_IOC_ENCLAVE_ADD_PAGES, &ioc);
+		if (rc < 0) {
+			fprintf(stderr, "SGX_IOC_ENCLAVE_ADD_PAGES failed: errno=%d.\n",
+				errno);
+			return false;
+		}
+
+		// extend chunks
+		for (chunk_offset = 0; chunk_offset < size - size_full_pages; chunk_offset += SGX_EEXTEND_BLOCK_SIZE) {
+			ioc_extend.offset = seg->offset + size_full_pages + chunk_offset;
+			rc = ioctl(encl->fd, SGX_IOC_ENCLAVE_EXTEND, &ioc_extend);
+			if (rc < 0) {
+				fprintf(stderr, "SGX_IOC_ENCLAVE_EXTEND failed: errno=%d.\n",
+					errno);
+				return false;
+			}
+		}
 	}
 
 	return true;
 }
 
+uint64_t size_fit(uint64_t size_in_bytes, uint64_t block_size) {
+	return (size_in_bytes + block_size - 1) & (~(block_size - 1));
+}
+
 bool encl_load(const char *path, struct encl *encl)
 {
 	Elf64_Phdr *phdr_tbl;
@@ -197,7 +236,7 @@ bool encl_load(const char *path, struct encl *encl)
 		}
 
 		seg->offset = (phdr->p_offset & PAGE_MASK) - src_offset;
-		seg->size = (phdr->p_filesz + PAGE_SIZE - 1) & PAGE_MASK;
+		seg->size = phdr->p_filesz;
 
 		printf("0x%016lx 0x%016lx 0x%02x\n", seg->offset, seg->size,
 		       seg->prot);
@@ -209,7 +248,7 @@ bool encl_load(const char *path, struct encl *encl)
 
 	encl->src = encl->bin + src_offset;
 	encl->src_size = encl->segment_tbl[j - 1].offset +
-			 encl->segment_tbl[j - 1].size;
+			 size_fit(encl->segment_tbl[j - 1].size, PAGE_SIZE);
 
 	for (encl->encl_size = 4096; encl->encl_size < encl->src_size; )
 		encl->encl_size <<= 1;
diff --git a/tools/testing/selftests/sgx/main.h b/tools/testing/selftests/sgx/main.h
index 67211a7..9d63bda 100644
--- a/tools/testing/selftests/sgx/main.h
+++ b/tools/testing/selftests/sgx/main.h
@@ -34,6 +34,7 @@ void encl_delete(struct encl *ctx);
 bool encl_load(const char *path, struct encl *encl);
 bool encl_measure(struct encl *encl);
 bool encl_build(struct encl *encl);
+uint64_t size_fit(uint64_t size_in_bytes, uint64_t block_size);
 
 int sgx_call_vdso(void *rdi, void *rsi, long rdx, u32 function, void *r8, void *r9,
 		  struct sgx_enclave_run *run);
diff --git a/tools/testing/selftests/sgx/sigstruct.c b/tools/testing/selftests/sgx/sigstruct.c
index aac9cbc..eba7c86 100644
--- a/tools/testing/selftests/sgx/sigstruct.c
+++ b/tools/testing/selftests/sgx/sigstruct.c
@@ -260,28 +260,25 @@ static bool mrenclave_eextend(EVP_MD_CTX *ctx, uint64_t offset,
 			      const uint8_t *data)
 {
 	struct mreextend mreextend;
-	int i;
 
-	for (i = 0; i < 0x1000; i += 0x100) {
-		memset(&mreextend, 0, sizeof(mreextend));
-		mreextend.tag = MREEXTEND;
-		mreextend.offset = offset + i;
+	memset(&mreextend, 0, sizeof(mreextend));
+	mreextend.tag = MREEXTEND;
+	mreextend.offset = offset;
 
-		if (!mrenclave_update(ctx, &mreextend))
-			return false;
+	if (!mrenclave_update(ctx, &mreextend))
+		return false;
 
-		if (!mrenclave_update(ctx, &data[i + 0x00]))
-			return false;
+	if (!mrenclave_update(ctx, &data[0x00]))
+		return false;
 
-		if (!mrenclave_update(ctx, &data[i + 0x40]))
-			return false;
+	if (!mrenclave_update(ctx, &data[0x40]))
+		return false;
 
-		if (!mrenclave_update(ctx, &data[i + 0x80]))
-			return false;
+	if (!mrenclave_update(ctx, &data[0x80]))
+		return false;
 
-		if (!mrenclave_update(ctx, &data[i + 0xC0]))
-			return false;
-	}
+	if (!mrenclave_update(ctx, &data[0xC0]))
+		return false;
 
 	return true;
 }
@@ -289,12 +286,13 @@ static bool mrenclave_eextend(EVP_MD_CTX *ctx, uint64_t offset,
 static bool mrenclave_segment(EVP_MD_CTX *ctx, struct encl *encl,
 			      struct encl_segment *seg)
 {
-	uint64_t end = seg->offset + seg->size;
+	uint64_t end = seg->offset + size_fit(seg->size, SGX_EEXTEND_BLOCK_SIZE);
 	uint64_t offset;
 
-	for (offset = seg->offset; offset < end; offset += PAGE_SIZE) {
-		if (!mrenclave_eadd(ctx, offset, seg->flags))
-			return false;
+	for (offset = seg->offset; offset < end; offset += SGX_EEXTEND_BLOCK_SIZE) {
+		if (offset % PAGE_SIZE == 0)
+			if (!mrenclave_eadd(ctx, offset, seg->flags))
+				return false;
 
 		if (!mrenclave_eextend(ctx, offset, encl->src + offset))
 			return false;
-- 
2.7.4

