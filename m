Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C69C43460
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Apr 2021 17:56:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED1516112E
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Apr 2021 17:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236952AbhDAR4I (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:56:08 -0400
Received: from mail-dm6nam11on2107.outbound.protection.outlook.com ([40.107.223.107]:19297
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237054AbhDARuJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 1 Apr 2021 13:50:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RaRf4jc2OnXGY01AVq63aVQEeIXgEd92TzwCkkLq+Sfpg4V/10q4gvIyaopcoMNAdbd4dg7vgflULzaFwsubhRsd7Y1qQ3ZgOTQhse3xyfRFG3B1zzSHlkP6U/XfNinoIAb9OJkdqHPctA1Q5kWxgmHzT1OkdNHCXxsWNkLXcKs2z3QVaSj1D3VjJSwG2JOHWjW12DfAWkDoUOmuXX0ZP6dzRHhq1O+G0ZzwGyTDb1OCR5R188ioK6LzmoWM6pRSxMkzd69Dwie2h87cwegJB1dLIvKqykFifYTcDUhA4jhqFeVDJjeE2HhnedEhuwEQfF/uTuUXsQHqXeXmamoEQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OpWnrRh3Z9+7FSr9YIPDmrdtvk7URUg7ryQieyG0LMQ=;
 b=admxCKhGvX1RALFCjGs/vgETpRw+p6RVKadRaUlQP0RIinFAGROInKJALXaOXb27uXgs+XS+9nol3V6jcEFKmDG+EZ8DMYzxI2rxqIfIvQkuEtCpGamAGP8X/ZVa2tUFkIkZruK5/LzaBjnGf0ZK4S9vC2E4TaIaQM8uhQ1lufx7iz5XmDxnZXoB1X8GVKUrzunNSU+5y8BN8v5TsBPhuh1cgXEK8IXCBvDdHeHV02XczfLg5G+GsRomJNFTM4HVImutNwIR0KiThORz3Kl9eb33ea3YTN8uYYi/VmXkJIbDgukvGjiLwsCxVyYXF1I4OgLVTg8B87IFmPKjI9G84Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OpWnrRh3Z9+7FSr9YIPDmrdtvk7URUg7ryQieyG0LMQ=;
 b=j7HAVUmr2gvWE0jKVybNrhiCQ3GMlKhr6LIjE0PxJYWgaT8M9rlXD/Tk5QDWb+RlIxqYhfk8J7eY2h1F2mFILtDSLDKkG8pzbv/YQqIABcp0eOh/c18icmP7COtCMXU6+DjI44fHR9KDPirInrbZnP8A0E327/XS31L1rKTyIBg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from MWHPR11MB1792.namprd11.prod.outlook.com (2603:10b6:300:10b::9)
 by MWHPR11MB1581.namprd11.prod.outlook.com (2603:10b6:301:d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.32; Thu, 1 Apr
 2021 17:50:07 +0000
Received: from MWHPR11MB1792.namprd11.prod.outlook.com
 ([fe80::3cc5:3909:3985:3fab]) by MWHPR11MB1792.namprd11.prod.outlook.com
 ([fe80::3cc5:3909:3985:3fab%8]) with mapi id 15.20.3999.027; Thu, 1 Apr 2021
 17:50:07 +0000
Subject: Re: [PATCH RESEND 0/3] x86/sgx: eextend ioctl
To:     Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
References: <9688abee-6ba7-e1d9-701e-a5cabac36269@fortanix.com>
 <c7b19652-3b5a-e864-1e0e-3e3d26944398@intel.com>
 <ece49a38-c84d-dba7-6039-b409511e7303@fortanix.com>
 <0498080e-6fdc-ed6d-8efa-d9c3265fe7e5@intel.com>
From:   Raoul Strackx <raoul.strackx@fortanix.com>
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
Message-ID: <9d15aae0-078a-ed72-6c14-155cd1bf27c5@fortanix.com>
Date:   Thu, 1 Apr 2021 19:49:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <0498080e-6fdc-ed6d-8efa-d9c3265fe7e5@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [81.164.43.210]
X-ClientProxiedBy: AM0PR02CA0201.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::8) To MWHPR11MB1792.namprd11.prod.outlook.com
 (2603:10b6:300:10b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (81.164.43.210) by AM0PR02CA0201.eurprd02.prod.outlook.com (2603:10a6:20b:28f::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 17:50:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cab9b6d-c2d5-440b-66cd-08d8f5369649
X-MS-TrafficTypeDiagnostic: MWHPR11MB1581:
X-Microsoft-Antispam-PRVS: <MWHPR11MB1581A50BC7185B80156A80328B7B9@MWHPR11MB1581.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZtE3eG4f5WiJOyif6gsmau14eLWn06vJRGHxvroqCy+CioKM3mpxMaBdlcmnP3NKpH9BSOQ3xVH/O4haso4bgWI0VWKprka7i2O/NOQwJT6fiJLsar5rWITxYeG+n3/v+zfJlwSt+rrbbRT4WBo88l9TYeX5zEeyldRUtrBrucg08sP1xq1pbcUYHeveTcGrs7edT7oh3kiIl2VRQowje59htQwPpHmsOp9d3P/JK1h+H74Gc4QgPlXbmA2Z3/8KQ8kLp59to+n72DHhrPJFDUgzmtquSWZpXgcELt7iI29XbW0Y7/c1MZmKgcXiQN9bLCAQtHjQdeI+qV2nBGnv3RQDjebqjqMZ9kEFZU1IfPFgWDWwDiY/c8sNYffZPWk0RqGL/5snge/+7yAxpil6w5zVZ/dzkJ5nqsjnhUfKqdnHH9bUv6me+Fs3VeJYOV2Us7B90OV7ExDGgkIR6Fuer9gvzvuOX3bHp56fIRRq5kqFnDa9cM4b1hsRS4ewJXrtRnTWxSqpLQTmxPFJjlc6Unv6lTP0ftwi6lmm6cwa/MiyLfNd1B6mr02iiRFZV9lH2bcE5dMaymq7yfnCjytVkiKKQxMgQfGeKKbnSQkaNnyV3NNq7D+GzCVyX9YoJ6dRla5JMVNM0uBBIBk2DMZ3PAtv/Yl2P0uESZejVaSxRNgkg7E88ZVZU9gcaRnQGGoN2KrHclBk3NC/wnOofRB4fBtFKvAGK/DTW/pMVPnGGbY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1792.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(396003)(376002)(39840400004)(8936002)(110136005)(16576012)(316002)(8676002)(44832011)(478600001)(38100700001)(6486002)(66556008)(31686004)(86362001)(6666004)(4744005)(5660300002)(52116002)(83380400001)(31696002)(956004)(53546011)(66946007)(7416002)(26005)(66476007)(921005)(16526019)(2906002)(186003)(36756003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q1RKd0ltUzR3dTc0a292V3hYWlJJVmFsR1JNbHBMSnBzOVp3eFNTUlllaG1S?=
 =?utf-8?B?d29CRTAyZnhBeEEyL2J2TVRGRDEwc3dKTnBaWnVwWU9US0xIWjlSRVFMQlpn?=
 =?utf-8?B?eWtYbThvdTZrRSsrVnZLek5NRVQ5U3BpRVBGTmE2dWpDTEJTRTVnZTFYeSsr?=
 =?utf-8?B?QytTcDhodEltNVZOcTdtNjhpZ01zeDRBNjZadTJxQTRmckM4d2ZRNk9sZ3pO?=
 =?utf-8?B?amkramhRTENNN0FhdndBYWE5R0RNQmVURHAydjNNU0NwQ3dkR2I5ckVFSnQ1?=
 =?utf-8?B?SWR1aFgvVitaVXUzMTE0aWt5WC9TMDQ2c0MxanpFVUo0ZlRWV3lvMjA3bzVP?=
 =?utf-8?B?My82Qk81aGpJL1lETVd6VXVqZWQ2dlBWU0dqY0greUdhU2ZONERmaHQrVHlh?=
 =?utf-8?B?MmNwNi9KQzBoL3VCa093WWFPd0xpMGExQUNrOWhlQU1PcUhoVnVINExadnhs?=
 =?utf-8?B?YXRaUnREVllUZmMxb3ZBVkszVFE1Yjl0Mnd3d3p1SDNxRlE4Mk1hVk1QZDd1?=
 =?utf-8?B?ekg3SExiZjB4WVROeXZiSFQxMmVWdUVlTTNGTGN2aFBrdkFCSXhlWWlpbmdp?=
 =?utf-8?B?bUxNTTdha0FQdGxMRVRyL3UvZmNpQUs3UkNLVVBJdHZuaVBLZGRJYlpWQm9Q?=
 =?utf-8?B?eHErMkpVZm1nZjdFZDFreGdBU0hVemlvV2NsMFFyNWl2QlA1dGNnU0tBYU8z?=
 =?utf-8?B?dXU1VDhwOFRXZlNCZ1VaSVJ0SUlJWm1DcG9CcXBndlBuVkRGQTVGL0xZWisx?=
 =?utf-8?B?UzYvUzQxamJIYmIxbm5GQWFBOFczNXI4MUdrZUhmUnJYWks5dGFrampQaWdo?=
 =?utf-8?B?SVBJNlNIV1Q2K280ZmpKc3dROGlnZXViekxJcXEvSEMwUlJpbXZmQnZ3NXVq?=
 =?utf-8?B?QXIwRC9RZkZsK0VMcmRjUXpzQ1gwbC9TalFLbTVIbkFlTUliNEFIWkZ1enov?=
 =?utf-8?B?K2J6UTlrNGQ2bStEMm0wZFhQcysraHZmVC9XeG04YUpQSGZjL21WMjBzOUFS?=
 =?utf-8?B?VkxGUjR1aktzdlBiOGprSzlJb0djTTE0cFhPMm0yUml5azZKQUt0STBNYXNU?=
 =?utf-8?B?RGhpRFBEUlZUZGt6VXZKQWd0SFEzYnNaQ29VYWhoNWk1M3oxdkNsZ29BSCt1?=
 =?utf-8?B?NnYrNWlCZlZXMzNIbzhKRW9Yd08wSmtXZkpEU3h3SXdrYTNUU3p0MzBscWJ5?=
 =?utf-8?B?VEZNamNOWGNKVUFMSG5ha01BbWEwYzkxL01CS0ppaGZZRmd0YWVQUjFUNGc1?=
 =?utf-8?B?S0hHb0dsLzhtTWkyV3FWa3pjUnNMZHUxUXBYamJHTDA5NXJUc0JxQS8vMzhh?=
 =?utf-8?B?dVYrUEpnYjlFeThqK0NKWWR4VVlyK2pocjNaeHp6QWRsWXltWXVpengvbDFn?=
 =?utf-8?B?Q1FnUW9KbkRzK3I4Nm9OSzM1NW9VNU1vL2ZjWllXVUs1NkVqZlNIVlhWeXNj?=
 =?utf-8?B?NldZRERUeHNkWUY2OGF4dmFqeVZJQnlCYlFpYnJvYkxJbUVua29jb2xxWFBt?=
 =?utf-8?B?SXdKbWREQnA2T0RwS1ZzU0FzbGt0RjBnMzBXN1ppbjRmOUVYZ24xbEQ5eW1k?=
 =?utf-8?B?QWZjUnpsNm9sK2o3UXRuTXllMi93NXVWVzdJYmpLQlJUb0hPd2MzYlo0YWpW?=
 =?utf-8?B?TzF5bzYwWFNKY0QvTzBmdThldzREaEtQdGJLNEl6dnRRSkd0a29oTVFldE81?=
 =?utf-8?B?Q01TcWZzSDhBNnE0eVNzR0g3V2FiZ3o3MVk5U3NqYzc5bTlIeEFCbXh4UmtZ?=
 =?utf-8?Q?ybaClnBM4ON4QtYPSeD570rq1YdtBfEYKm0B+UT?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cab9b6d-c2d5-440b-66cd-08d8f5369649
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1792.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 17:50:07.4165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x+QwsY5tvMLXWbqrr0cxqB1kYT5OtOXbfHIJXnd5d+hGRxzBHaWjlKRWZdKT8+A0vXJHeGhNeripdjaNsRWddkta6xOH6y6h4YeN/BnIX6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1581
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



On 4/1/21 6:11 PM, Dave Hansen wrote:
> On 4/1/21 7:56 AM, Raoul Strackx wrote:
>>
>> SOLUTION OF THIS PATCH
>> This patch adds a new ioctl to enable userspace to execute EEXTEND leaf 
>> functions per 256 bytes of enclave memory. This enables enclaves to be 
>> build as specified by enclave providers.
> 
> I think tying the user ABI to the SGX architecture this closely is a
> mistake.
> 
> Do we need another ioctl() or can we just relax the existing add_pages
> ioctl() to allow unaligned addresses?
> 

I've considered this. In order to do an EEXTEND without an EADD, we'd
need to add a flag DONT_ADD_PAGES flag to `add_pages` ioctl as well. Two
separate ioctls, one for adding, another for extending made more sense
to me.

Raoul
