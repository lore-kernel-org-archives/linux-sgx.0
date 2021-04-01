Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE001C433B4
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Apr 2021 17:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AE996112E
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Apr 2021 17:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbhDAR4J (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237332AbhDARv2 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 1 Apr 2021 13:51:28 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on20705.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::705])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE54C001F77
        for <linux-sgx@vger.kernel.org>; Thu,  1 Apr 2021 07:52:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lx0h4B+UvDaHnmPBPOerYVIdY2jawBomhn5Nt37irD69+0+OGZ3w+G0b1s/Lk/Gkcg1Jx1eYB2yJgILSqqfPsM0r2Leao+dO7bbxZsS4IMYnKTKmpSO2aFM9QT3m3ptpsj3qOVXWbg/1+XWaZ6d6VWJIr7gxYkKAicmjZk7tLujpXBdOvGU1AbpzW19gU51PrlIloAh25vOhc6eS/qaOnr4eo457fgplIICUcPQwKCHWxXC6303R6d5CSz2PzCSgTIrUU6+xWqih9JWbSL4vMa6k8fnfbdEyIctxL4iX64xLIDKAIh4UGwcwyIcs5Ht1jtwbMZnIsFJ1gesXX94haQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZNLf50mZKSvjyZoyfxvymgkzFuCP6sKxsggKyUXvj9E=;
 b=Zm/ffvfF3/ywe8fI3AaKcqjqSNtwmzL3mnB2E16IFaRS86Mo1wyCcxr8oaNeRFyuNny3ce1qype1bF13F4sWsUq/DKKNEvFdrA5ogYmOCkD7fTJj1qEkxAMCzwnW2RYt4oEsq35n1WHt/PoJ6pgivHCiNzccahDWciJpgoB2GM3xw8cnRSztvjzOdsLNociMfp1H7yhVpSPny0SHm8DkXDPS5VTaNAarkzhV9rY4M9t2wSMbjkbzuNyGUH8K6ZF3i2jTmzRdH0jDIpJgJde0qi/y4qWacICVzQdOhNB/ep8/6vjdvoMnIHO8OfyoNRXE5ex/gbgLWUkTyVwkCNNTuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZNLf50mZKSvjyZoyfxvymgkzFuCP6sKxsggKyUXvj9E=;
 b=KzdVVNfNT3u8Xg0Gob4MEB4+inWPXYW6fSXV7YuFDwfyKt1JFbbabpwbP40o4ojJ0DSzOvXlycqnm2mACBFrcDBfVS/zziXZZo2DW/zggC255wmuwvMRI+UQqYf+8dHpoUOaqEWx+s14Z0/HuLcMD29C6XMMxoPpeWSt57Rxycg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from MWHPR11MB1792.namprd11.prod.outlook.com (2603:10b6:300:10b::9)
 by CO1PR11MB4769.namprd11.prod.outlook.com (2603:10b6:303:91::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Thu, 1 Apr
 2021 14:52:10 +0000
Received: from MWHPR11MB1792.namprd11.prod.outlook.com
 ([fe80::3cc5:3909:3985:3fab]) by MWHPR11MB1792.namprd11.prod.outlook.com
 ([fe80::3cc5:3909:3985:3fab%8]) with mapi id 15.20.3999.027; Thu, 1 Apr 2021
 14:52:09 +0000
Subject: Re: [PATCH 1/3] x86/sgx: Adding eextend ioctl
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org
References: <1b002a72-139d-0ed3-28ea-0d4980e110f3@fortanix.com>
 <YGUELcaqrETXiv3R@kernel.org>
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
Message-ID: <00f68d3e-9752-80f1-d73c-8c4447cf0518@fortanix.com>
Date:   Thu, 1 Apr 2021 16:52:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YGUELcaqrETXiv3R@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [81.164.43.210]
X-ClientProxiedBy: PR0P264CA0055.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1d::19) To MWHPR11MB1792.namprd11.prod.outlook.com
 (2603:10b6:300:10b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (81.164.43.210) by PR0P264CA0055.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 14:52:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09ef47f0-8ebc-4048-44fb-08d8f51db9e3
X-MS-TrafficTypeDiagnostic: CO1PR11MB4769:
X-Microsoft-Antispam-PRVS: <CO1PR11MB4769DB73698DDD6483948B028B7B9@CO1PR11MB4769.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jVFgQPFnHG34Pso2V08F0psxcn0QL1FeWUDM+lBSxJIgToU+ZXPtzwJin4T7hT9Vup9uJCSyaAeVXlwv+rmdmLi4eADLTOou9GeQvUiSddubPn662FKzpg9hpMQphBxAvFZgzQ7N9sWG8+SmHCMbslQOPA3Nv8zmrmBC4WPnezoeOUI9GMfJ8FOlFmcuUnuHPD0EQtgqaRmqPIJr1N4aCe2MRYMRrGSAVIXJpNm3ORygc4zL1+SqmbgQOH4P70IRhJ+3LUbXsjJpSkH4UTdnb4HDtovejhWyV+RcB+e2vTtCoEofQQr2Stb7H8O+3nJkhddR5yZgJVoZNCeUFb3zSHxbXJpWVwoATgD5u0Z+hrRTzLsAxMrS1SEmRgO+nL9xaIPDZdgkAUqVuADT7TekCJkbfZIvD22lE8s5/hOrdvqiKildXbLBLjO6P8CVLme2VTLzBI242552UmlZ16svTz0R8TBM98ZsMoHjhIdjGfcq2uP2v4qS1rWAoBHRUc61/NJhIuLhik4jqMU2M/LZ3RBrAz/AhPv1LExlRXvbTdFFqr5YiDunNGPItjiczvNNIWMt8jPKkZPhmRbOuS5z6SVY6K99Aigta7aiXg3qpGQFGfnWc/ovqgEljGfdA1d9bSFgf4DR5dy57zu5tvJTIPCro4Mers/4K5KMMbDsynD+vJAH7NVUqp1AUcPl0qdQzOl6tJyjgqqqtFzx/4bALA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1792.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(376002)(39840400004)(366004)(26005)(16576012)(36756003)(4326008)(2906002)(5660300002)(186003)(2616005)(6666004)(956004)(16526019)(316002)(478600001)(6486002)(83380400001)(86362001)(8676002)(38100700001)(6916009)(31696002)(44832011)(66476007)(66946007)(66556008)(8936002)(31686004)(53546011)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cU03Q2plMnE5cUxSSERtQVl2OHZaTVVva09kd3U2aklBWlNTd2I0WkJrWS80?=
 =?utf-8?B?SlpQdkdJZTJ2RmU2Rzlxemh2R3VVbHFVZk8zTHgyTWNpUVQyOThGc3BFaWdP?=
 =?utf-8?B?ZUprNHlrQWUyME1hL3V3bCtEb281aHk2ZnNuVVpSZjhBby81TmY4RDRHbG80?=
 =?utf-8?B?L2NNV1dqSDdSNTRCOWN3NDBHcXozNU03aFhQZDJsL2JUK2cvSHU3SVFiQkp2?=
 =?utf-8?B?bTd6VGQwYjhURFRHbFlSa0JoTnBZMlQ2YmRuUTNtYWNyY2orSW82Vmw3YnVq?=
 =?utf-8?B?dDE3SWcwbTQ0YkhtR3c3SG1WR0lCMXNYdU51OGY4U0xFS1FKd0V6SUtJSjJT?=
 =?utf-8?B?RXZlOTVJQ0Q2N1FBNE1hd0kyd3VFZHUxcGJBSkc1V3FpYWJxeVNKRitZQlV4?=
 =?utf-8?B?Y2l6RmpuR1Zvemp3b1o5NkVNUjF2Q3FudlU5THZuM3ZYOURNcm95YnNXRGdn?=
 =?utf-8?B?YkEzemVJbThzaUtFaTN4d1hlbHh6c0hYcDZjMVRna3dtL25qdlNQUFpmSGZK?=
 =?utf-8?B?VDVERUVTdWUrVGdsaFJvRmkveGVCSTV4d2haQW52WW41ZlZkUU92bCt4NzV0?=
 =?utf-8?B?M2Z3Wi9CNTZDdGhLTms0TkhFcjdKRXNOMGtYWmc4Ym5TNGU4OWtqTU5wVnlQ?=
 =?utf-8?B?MzRlQXhGYi9jUDBrMU9GTmxJTjgzK0tUeVR3SjBvbjUxa3ppNFpieVNtU3lz?=
 =?utf-8?B?b0NLdUkxRSs3dGZCQWlRVmF5R1RObTV3NHBmamVkc1JrUTkwZ3FFbEFPWi9L?=
 =?utf-8?B?MnErbDhvQVh3WDhDdGw1OHRwLzQxS0RLbG94bDF6WnVIeFFKcFdGVHJxTWYv?=
 =?utf-8?B?RkF1cVhQcE9wTDJGZmdoWEZOeEVCU0dxODZCc2dLTGkraWtmaUNZYU1IZHRp?=
 =?utf-8?B?V3E4b2M3alArQndsRCtuQ0M0YmswR1NOQ1lGM2xqL0gzOFdUVnY4YnluUDZP?=
 =?utf-8?B?eVcrSkFoUEFPM3hWRVdHYlVyWGZSYjB5R2YxY2ZRR0Z1dmo1VkNJRmliSVNU?=
 =?utf-8?B?V0VneVFLWG9lOE9xTEZIMDcwaGdRc1d6cXFWSnRHQWp3ZDg3TUJieVc0ODF5?=
 =?utf-8?B?ZURFTHlLWXlEYzYvRTBrdTd2RDQyZEdXaGhiS0VzeWJDdlFJVUtscVBrL09T?=
 =?utf-8?B?a1pBMzNPVlNWc2RHL1hoSmtMZVBISnl2Y2hCYS9TVlkwK053Q1NYSUlBbUJ3?=
 =?utf-8?B?dnVPZFduZFR5MmxCUlJyRnZyRkJyTVhQSXdKMEdmcnljSlhaZWtjUmhsUC9a?=
 =?utf-8?B?dUQwdWlhcTdIVGtPT3R3b3o5VDFqQVQxVFllQ2xZaGlYOEdVZDB1T3N1WmhH?=
 =?utf-8?B?NHZQTzNxNnFEV29TeHVFbXhPaUFndmRhVC83Z3R0blN5T0dYRW00VGs0MFJt?=
 =?utf-8?B?QkQzZlkvbndYM3NMZzBLbmh3SnQxUzZpMmJuR1FsRk1EeTV0WStNM2Rsak9M?=
 =?utf-8?B?UVhDeUcvMEJvWm9BUTFNRDdEVTdWUkJJdy9uWHNKMXhHRnd5RFNZRGFRZkQ4?=
 =?utf-8?B?cWJDS2d2MU9SRllTTlp5cm9PaE00N21xdzRwSldGM2p6bGQ4YlNxQi9iL1M0?=
 =?utf-8?B?SWVoZkZnKy9vNTE2MGFTbEp2amZPeG1zekcyejFwK1krR04yN1VuN09oSmtP?=
 =?utf-8?B?YjI0S2k1UThIZmJaTEVJRm4rSGNod1ArQWVKNnhaNTVCVm9NV1prZkMyUEpq?=
 =?utf-8?B?cHlEbXdxV2p0bkpVeSthOTR4dnczeDdZa3J3NFF4MzRCdHhJenZDS0JUL3cz?=
 =?utf-8?Q?Ge6R1JTnBcjk8zHwk4sutYpJ19xnk57MF9qwgPM?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09ef47f0-8ebc-4048-44fb-08d8f51db9e3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1792.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 14:52:09.6620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: niLUt8Hdqgn82wWfvJE8Y30GWIabQ2+l9cK3Lk1fS6oRS/4C4idEq+U5fSSHo9fjKcxqgEGS14gcGSp0WhEQwqWeSzCwUzKicxwI3uI6Ssg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4769
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 4/1/21 1:22 AM, Jarkko Sakkinen wrote:
> On Wed, Mar 31, 2021 at 02:18:50PM +0200, Raoul Strackx wrote:
>> The current sgx driver can only launch enclaves that always measure 4K
>> pages. That may not necessarily be the case. This patch adds an ioctl to
>> enable users to add the enclave measurement per 256 byte.
> 
> Please run scripts/checkpatch.pl. You cannot write a long description in
> a single line
>
> Also please write 'SGX' instead of 'sgx'
I've made the requested changes locally and will include them in the next
version of the patch. I'm still very new to the Linux patch process. Thanks
for understanding.

> I do understand the code change but also the current ioctl measure per 256
> byte the full page. What I'm saying that the long description does not
> contain any information what this patch adds to that. It neither makes the
> case why it makes sense to have enclaves where full pages are not measured.

Yes the description was too succinct. Dave Hansen had a similar comment. Let
me reply to this in the email thread with all appropriate addressed people
and mailing lists.

Regards,
Raoul
