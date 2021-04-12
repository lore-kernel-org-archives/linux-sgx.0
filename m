Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD6BC433B4
	for <linux-sgx@archiver.kernel.org>; Mon, 12 Apr 2021 09:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1669B613B2
	for <linux-sgx@archiver.kernel.org>; Mon, 12 Apr 2021 09:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239693AbhDLJIA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 12 Apr 2021 05:08:00 -0400
Received: from mail-dm6nam12on2125.outbound.protection.outlook.com ([40.107.243.125]:21408
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240410AbhDLJF7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 12 Apr 2021 05:05:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UdtQiae4CiTlqk25m8FCCdg4Ve0p5XYyoyugg8R1CZddoSWlBDeRCbMrT4Nn1B4LI7eJgc+nGSQtpaQQfLliKN3JEOYC799ja2iSNF02R8uVKw7Wmcr/4MnTuXDIJnaR+ona+yA8lopazaCqIjjNlF5eBuplAc18thnEPrTI2dLgcpn/BcDyrFjZ7K+gHPW8Rn5nafxJLh6cG36aKNjL8FJFnzNutEcDf2Ykv91qqh2yIsOQOUDZmFRgGLGeXSWFzSAAnGUCz+EbpW0H19RhoOfvvxo++puaY5xrEuAApMpufrY25omH+SXolFJJHNul7IIQDq5O+EyHEF1qlHWNZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TIMyh1T7JtlOImyWg9N1qmyoboI7O2xx1L9OBV80WA=;
 b=ln/B7skjQnHMZL0haMEMS+spALykwLGbvZJoTMa4orkuGGdFncluy+P1uUYsWVhK2V8jtGJkuBL9xrTXTNGL7YcYJRm/J4UJI46ysSXzt5b8hqc86COxctuo0ipTGfBQtQCWjBQIynL8+B5moMKW3i1soZHvnW6yvNk/RwHZ7tf8LgDxyhMRXq9c5s7HlTfa4AfKC8JTOKqjzCvl4S7cyjnCY0/nONrDiqsWnf+K0UN8jV6h/QB9iyxyYDzsClVYQ/NXeIlLoKGsCTAu+DZvEDDfi3cRyIkEVHElnnNOY0urCYf60LcKtdNnw1b5K/996ije67eOOcve/zqhLgWtpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TIMyh1T7JtlOImyWg9N1qmyoboI7O2xx1L9OBV80WA=;
 b=amGMm+5UujIHQWWbjeG0J768uuboRyq11Weg0bCCB7gmpGJCUl0xpbuRZewFtaxbO+pNQpOsOj5+qujQtoBqTafX+S9CdzMmSuKiyeuODeRk/E0QSyo/CVCUzmbncFr6atAU8adPaxyvxeDoxFkXORGPUPOj1pUR4fZClCXBQdA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from CY4PR11MB1783.namprd11.prod.outlook.com (2603:10b6:903:11d::20)
 by CY4PR11MB1384.namprd11.prod.outlook.com (2603:10b6:903:2c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 09:05:25 +0000
Received: from CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::f052:14fe:c2a9:5fb1]) by CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::f052:14fe:c2a9:5fb1%3]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 09:05:25 +0000
From:   Raoul Strackx <raoul.strackx@fortanix.com>
Subject: [PATCH v2 3/3] x86/sgx: eextend ioctl selftest
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
Message-ID: <b030e2ee-cc3d-3f4f-897e-210949bb91a4@fortanix.com>
Date:   Mon, 12 Apr 2021 11:05:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <da7ae1e7-59b8-63db-a9f1-607b4e529639@fortanix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.164.43.210]
X-ClientProxiedBy: AM0PR10CA0049.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::29) To CY4PR11MB1783.namprd11.prod.outlook.com
 (2603:10b6:903:11d::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (81.164.43.210) by AM0PR10CA0049.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 09:05:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b277c64-2977-4d30-bfca-08d8fd921c31
X-MS-TrafficTypeDiagnostic: CY4PR11MB1384:
X-Microsoft-Antispam-PRVS: <CY4PR11MB1384F4720BF91F22192EAECE8B709@CY4PR11MB1384.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RJXKH+bZzhcVZisvDlT/PpoE498M5uFjdFxQe+sI/0RsvWUiMDlbpQVJEDvE5jLP8chfWSaSUNA97cmBqg9qZoE+httsOwRSpA8I0EEuF0Zzk+7FE64lzvzKdnLYYe6LydTkRAqeQouziJXcjPU6NfaxsVC32BfIgRPDsF+weyPGKGYIl+R5810A0qi4WSrurIzk7HAAte+DC3bwxofwkT/LvpoQ8vww8zt6oDJQE8cDf+Lv8bMu0GmbIVfY+nQQ8mrERKRbiZB63W6jiphMtLy8H8BZY8E5IMyxcSo0DETkm0vnX6rugRa5SqFZ+z/kfYBcFPhNE+hweRsmCWu0EVWviMWDRY4rb8RcXkida8kQU3qC9UM7eC/YeCR/FvPfELosSp4CFKFE5+IMYx5YNf8eHgzKcSRnNOic4XsFzOcNc3nPnUvH8mvMWdCHrhPPVncZKbjBWw6wOkMgBODWCsLcuwpZFnl0iycfNX8W3qRBXsXgI8kUwrvV0ygC3vip1PCotACjmEgiRCN1YwHavNjXJUwNFqLbypCzvUSRPuz1km7Z70G0hMKPfpv/NJMXvyhCXhMEMiadzh1YX7/0BaMmdQLczp+EYawr+nNVJphzTS0ybcz0gMqVS4ES1T7VtXRYamonvU4lj66yM2oGmB/zD3d4GEil3tGOfcqGLX/n9JYuvR97EfTfPOEew6yUQZ1y0ejeHRz2YXtrd33izUEFsgi/4M1M0lvxVwY00SI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1783.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39830400003)(376002)(136003)(396003)(366004)(26005)(66476007)(6486002)(186003)(16526019)(66556008)(44832011)(5660300002)(2616005)(38350700002)(316002)(86362001)(6666004)(956004)(66946007)(52116002)(31686004)(8936002)(8676002)(110136005)(36756003)(16576012)(2906002)(83380400001)(478600001)(38100700002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?blVTM21SNzkzTldVMytjbWJjbGtUUVlsYmtpMC92R1VMVDBUbjRta1lBemhU?=
 =?utf-8?B?UXY3Z2d5a2M4VzlsRTJwMHRmR1JOaktUU1l0SjlrQ2NXSVlFUUNhalFqWmFO?=
 =?utf-8?B?VEl2STlpTjJFYUxQS2tJeDlzYzErMlhjU3FKRzl5ckNibFJkTHpYR3B1Rk1T?=
 =?utf-8?B?RGowSU5SNm1wZFpRSEFXQzhmUUo4YjhtQlIvNS80c3RFNWFGUDlkcGVtQlhU?=
 =?utf-8?B?UmZla0lKdDhjKzhiZDZWRWhmUCtOVnBnaUR1aUpBODJGeE1VUzNxVUpIODVp?=
 =?utf-8?B?M0VMb2UzZFhia05qaFlYZWNqSlJHOVc2SFNYUWd2Wk14MVZkUTJObFFnNlQ0?=
 =?utf-8?B?UmtGaDhMUVRZbXplNE1OM0dIbHF5ZVdRdGE1Q2JDZThoQ1cvNWczUXRscktj?=
 =?utf-8?B?amd1S2tiaThZZlp1YUphaUZoempudGw2TmJPSzBTYkE2UGllYXRTYmp6SGxk?=
 =?utf-8?B?bWppci8vVlplbXgrS0hXbjdwcDR1anpoVFpqdHZNbGthTmdSTUJ2WHdGcElI?=
 =?utf-8?B?UkVlNCtLc2VraVExS2pTcGtLY3VtTnVMR2JoZG12eldrRHR2RXI4QjdwZ2RH?=
 =?utf-8?B?eVJEVmExRlpLd25STGVuT09NZXE0WHZjQVJrb2NyZWJ4VW1GMDAzdDdndlZj?=
 =?utf-8?B?VUhaT0Q2eTExTmZZeEFIa0IzUmZpcEkrOVhydG9PYXJuU01SdWd6MUxwSU9x?=
 =?utf-8?B?a1YzY2VWdU1Vbkg2MTVnRkM3dWFDeENMYXFTM1RPRjVIcXZYNEZORnNZNTV0?=
 =?utf-8?B?UjBWM1Ftb2lQOFNaa2pOd1NscEpoZ0hWVlJROVFwZ3J2U1FpR3NuV0FaaU82?=
 =?utf-8?B?U2wyOUxlQ1JJNFFPbVprenlEK2R0U1JqSStTUFNMZklNdVZkLytnY3FYV0kw?=
 =?utf-8?B?cFBHbmhSYkFaU2VaWjhOYVM0cXorZDdxdGE4cVBQYzRwODRMT0tURXR6Ly9H?=
 =?utf-8?B?R3RubmRaWEtKOUNoRVpLQkk1aHNqN3NKcGVFOXNtemFacHhLSXIySStlU1do?=
 =?utf-8?B?YmRHM1d4K0svbnkvSFd2bnhQMFpQL29tOWV5RmtLKy9CZUFvalVkY0Jxdzcy?=
 =?utf-8?B?WDdvNkFXZklwNUVZVkw0YjBEc1NKV1ZIdWlWSXhMeW9yY1ZpR1ZGdG5xWnhx?=
 =?utf-8?B?bEFhekFIZFZDeVBNdUJFZ3N4Sjk0c1k0ZklqaHNORzZJRG1UVmpVUU8rNVYz?=
 =?utf-8?B?cHNhaVNjTWNIMG81MTFwOHYyK3drTDhGNDZqaldxVWJnVElIa2c3YWZlL0Q2?=
 =?utf-8?B?b2xaN1lHWEJJV3RDMmorcU0zeTJsMkRsdFlzYVlUcmx0NHQrc1JrSjhNU043?=
 =?utf-8?B?TDB6TVhEZjVmV1QydmVSRUpqbGFhYURpcGRXbjN3QXRlOWxtdU9DRmRvb0dl?=
 =?utf-8?B?VVZSazVXZ2tUTkJXUlJReVl0RGRQNG0yVE5TMzZlR3RJYzV4aEIvYk9sOEww?=
 =?utf-8?B?SkpYUnFoLzFvS1hwZmM1T3ZtY09rNURXVXluWTNHdm52a1JEOFFWOXUrd1FH?=
 =?utf-8?B?US90ZTVxSnQ2eE9DZXptaDFZdWxNN0NYMGZVMXNSTngxTGFhRy9LdW1QM3hU?=
 =?utf-8?B?RXlCQlFWTzVRb01yY05jNnVRNUFIN2QydjJRNmM3YUZSZHVvK2xxWXp3YUlw?=
 =?utf-8?B?dFEwVG9GSHVTNmtmYXhCV2M5anFPTVlKVjM2MmFTTU16dWFUZTFKSFVWOE5j?=
 =?utf-8?B?N1BvWWwxZEVTbXU2eklpMmRIY1JGMThheEEzSGhyM2p4a21LMGdYd09VM1pL?=
 =?utf-8?Q?x3sgpFUy1d+4ojwdcHBvJMBSPBBgAYu92zxCZEZ?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b277c64-2977-4d30-bfca-08d8fd921c31
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1783.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 09:05:25.5139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0wWAfBmcR+UJOyDaFugcZtCrh8OcznnjAOuX4Hhk8qzdhkAJ2y3/GDqccNCsbI7SkuL6D9RV1Nl4goyGcendxReThj9zVliamPCNNNH6ob8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1384
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

In order to test the new eextend ioctl, the SGX selftest is modified to
only partially measure the last page of segments. Most segments are larger
than 4k, so the MEASURE flag for SGX_IOC_ENCLAVE_ADD_PAGE is still being
tested.

Signed-off-by: Raoul Strackx <raoul.strackx@fortanix.com>
---
 tools/testing/selftests/sgx/defines.h   |  1 +
 tools/testing/selftests/sgx/load.c      | 57 ++++++++++++++++++++++++++++-----
 tools/testing/selftests/sgx/main.h      |  1 +
 tools/testing/selftests/sgx/sigstruct.c | 38 +++++++++++-----------
 4 files changed, 69 insertions(+), 28 deletions(-)

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
index 9d43b75..39484fc 100644
--- a/tools/testing/selftests/sgx/load.c
+++ b/tools/testing/selftests/sgx/load.c
@@ -102,28 +102,69 @@ static bool encl_ioc_create(struct encl *encl)
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
+	if (ioc.length > 0) {
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
+		for (chunk_offset = 0; chunk_offset < size - size_full_pages;
+				chunk_offset += SGX_EEXTEND_BLOCK_SIZE) {
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
 
+uint64_t size_fit(uint64_t size_in_bytes, uint64_t block_size)
+{
+	return (size_in_bytes + block_size - 1) & (~(block_size - 1));
+}
+
 bool encl_load(const char *path, struct encl *encl)
 {
 	Elf64_Phdr *phdr_tbl;
@@ -197,7 +238,7 @@ bool encl_load(const char *path, struct encl *encl)
 		}
 
 		seg->offset = (phdr->p_offset & PAGE_MASK) - src_offset;
-		seg->size = (phdr->p_filesz + PAGE_SIZE - 1) & PAGE_MASK;
+		seg->size = phdr->p_filesz;
 
 		printf("0x%016lx 0x%016lx 0x%02x\n", seg->offset, seg->size,
 		       seg->prot);
@@ -209,7 +250,7 @@ bool encl_load(const char *path, struct encl *encl)
 
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

