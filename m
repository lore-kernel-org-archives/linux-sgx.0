Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 537F3C433E5
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Mar 2021 12:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33FCC6199A
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Mar 2021 12:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbhCaMTj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 31 Mar 2021 08:19:39 -0400
Received: from mail-mw2nam08on2110.outbound.protection.outlook.com ([40.107.101.110]:19361
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235458AbhCaMTS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 31 Mar 2021 08:19:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jjWbfRxoolVdFRmc0wFRWNQEOwX0Ms4n9e7Ag5a5ZMLwG4hbVSLeSqIpk6wNFcHxL7mHEs8oFoTTHGnQfB6mxyEW5EASrC+Wm6SGTCKyCrEmJWAjJAUG2+xicaKnCulZbXteIeXLejI3VH7/hDiyynVwiXi9t1ayizg3x6rVCFODdln2awi8VeMB4uG30cfv8L3KMB5x47f78+1diOz6aLw6OkUkPG68AFGPwRTP+hodPNXCm8/yMYAHs9fr8RIm/50JEF+R9zerttrcT0D91bY8MZE2JysOIQ+GNGq5SvZ/l4TBSPD09Un1tVyHkERI8PY3iqkqNFwOLkVGs6W6Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqIDBIId0r/jciEbDQvNbqQw3t1U1ULHQU6gI9otkho=;
 b=QyDmgNXA+MmcRD9SNphkXYT0XL7IK9ny6mOn8Li19+VNBsQffULogzoFAgy9FVqCpsMP/iKxFCjrvPBL7QbGV92B37B7o6C3IRtfXaCgbX+CZ9EOm4SE8TaDWkPdpvwLSwXIEGIhROLJ5x8VKMrq5tx6cPgLPnjeWhFVOCPpPRez0ie7cY3ssaXtWF8+3qjxtAbVq+SLdLMVYRCJCPsIiuAD9ILPujK4KSq1AhjUZOa269I7NwzkZxNWIuyL1b8yfN+VI9R06ECwB1h5Z8SRHcZU9Ps/Gpg4B0gVmzpwE0U+9SiokNCp/AHdeXG48XcOAgZuSsStobSYOvKW5qZ3kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqIDBIId0r/jciEbDQvNbqQw3t1U1ULHQU6gI9otkho=;
 b=H6ii+JY/elM9/c6HqtrTrpj7rChGfaO3O8EmtrHhzO9DFcCiPIgvheDvY2Y1yrX+e5HnKXF/ZTt2Bc8LXWKJzGuhl/D3NL4KBba1r6aWzGMRic6lHD5UtEWoaXYZY+4WJoKSTatwWSpGdrIHmWyBJqcnjIg00yU9pnsxAGolnlM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from CY4PR11MB1783.namprd11.prod.outlook.com (2603:10b6:903:11d::20)
 by CY4PR1101MB2312.namprd11.prod.outlook.com (2603:10b6:910:1c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.30; Wed, 31 Mar
 2021 12:18:57 +0000
Received: from CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::6dcc:f099:6ba8:6ebe]) by CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::6dcc:f099:6ba8:6ebe%10]) with mapi id 15.20.3977.035; Wed, 31 Mar
 2021 12:18:57 +0000
From:   Raoul Strackx <raoul.strackx@fortanix.com>
Subject: [PATCH 1/3] x86/sgx: Adding eextend ioctl
To:     linux-sgx@vger.kernel.org
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
Message-ID: <1b002a72-139d-0ed3-28ea-0d4980e110f3@fortanix.com>
Date:   Wed, 31 Mar 2021 14:18:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.164.43.210]
X-ClientProxiedBy: AM8P191CA0027.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::32) To CY4PR11MB1783.namprd11.prod.outlook.com
 (2603:10b6:903:11d::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (81.164.43.210) by AM8P191CA0027.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Wed, 31 Mar 2021 12:18:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9512ee9e-9fc0-4864-d387-08d8f43f2868
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2312:
X-Microsoft-Antispam-PRVS: <CY4PR1101MB2312B16D8D5B5F79B8D604278B7C9@CY4PR1101MB2312.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hZ5EOp0SSGXdobulh11mTbksUqmV7tJjW6kOgqW1T2x9dhjw/eSVbbyP9VSdcczYaSZby6XYzvFptpn7cRXPJ9I+J54wC5BpMzkORMqrgbyorPzaR0T0XVe42zAVtPdNWeqYPFko9jw/rpwn8pfYvddaxnjPYoIkMSXaH8STvMC4LLfSu4tyjn40oJ05NczejaKNu5kYsSGw8ZtoZ2XipQG2hZjh4Qe8wC3BRfR12Jy1lH6wdTaziINbjuUUrPH0wkhQh+2ig2hLKzgdpiKPaAw/B4Yy8UQbWC1sXm4DyNSoQ4McFOGACRZq5acX4HGf/E7sFgC4sqTevcToYQHNvsEFYIBZ5WkkSdw2ekjK5UQrvVlqi3WZyhN4mD55swvBLVkSCsC5BXTc1IGhY3enNBZDvi1QMceBOKa3qB7rHDtArUHyDSjVObP1zuJukWD8yuD12nBLJq6DYw8jHaszKnNDUKQxGH6ynF6zwUqNc825y0JwVmS3oVt1Xe6rZNSgW/0k3kc7DEfFNjBgRqL89QDjVyfXTUF43lrKCBUI6PbhV2cP0Y8B6TuqNABp0RDH4e0MXwk8EtFncsnmkRXH7/GCcUrRmbyP4zQjLKPuTQ5es+5COkVEyXNNtMlRbUCEkTJZKSpcp02hM2UrO1RiLLHqhsTWeSXjOyOWBeP0sZuR8HHE+lXcDIQGrQQlQv7aXnYEbkZ57YcKz1z3Wmjs3zkgFnL3Ln7XY+xniTGbZkw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1783.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(396003)(39840400004)(66946007)(2906002)(52116002)(2616005)(6486002)(5660300002)(8936002)(8676002)(956004)(36756003)(316002)(44832011)(38100700001)(66556008)(66476007)(6916009)(83380400001)(86362001)(6666004)(16576012)(186003)(26005)(478600001)(16526019)(31686004)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bFZqOWxTdy9ET2t4SzdhZ29SQXFlQVdIOWF3RFpndmlnWDRnMnVoRjVid29y?=
 =?utf-8?B?RUw2NnIyYU1WeVhpTnV1dFJEQklxQk9TZHdTZ09FdlRjMzBHZFdwVjlaRkVB?=
 =?utf-8?B?bmZGUDFBalRLbUF4WlJyZ1NDSXJZY0pCV2tlRjAySDUvT1lFd3dROEo3ZHk0?=
 =?utf-8?B?Qm5xbW1tckFBU3RWOVY4ZEgvUXVnbE82dEk1R3d4WEEySHhhL1FSd1Nrbmxh?=
 =?utf-8?B?SERGSnVablJxYXZPUXhoWXorZ3FHU2FrSjFUS09rSkcvdDBtaWpzV0dpVTlC?=
 =?utf-8?B?QnZ5ci81MzRQc1IxN2p2b3c1Kzh2Y0lqRGQzVHByY1ZPZWhSdzNTc1RvQzlJ?=
 =?utf-8?B?bGJLWHRZSWNneXU1OUhDeEsyVUxoZUhkaVVDa2paK0lJQlphaDRhNlkvVjF2?=
 =?utf-8?B?TUhTSWlTSWJrb3RCVm5rdjY4MXZPc3FYRHAxWGd6NTB2ZFlSU0RlMFlTUFNW?=
 =?utf-8?B?eHBJTTZLRitIc0ZUdW54VE93UDV2MFJTUm9IeXVXYndhdE92UmY3elFCRFlx?=
 =?utf-8?B?cEJrUEJuSGpJUTZ4ajhwallTQ3Bpb2Z5OTlXcHEveE5MRGpqMnZvUlZkL1Qw?=
 =?utf-8?B?bURSdW1PZk9FUnFnM0hxVXlENmU0ZFNINDgzMTZxY0tkOTF5c09TcGpzUmls?=
 =?utf-8?B?Q0RhLzRRN3FnVk5JUUpGdkt1ekJEdWdzQzU0Z2MxWVBpUThxNXRxUlZsMzZz?=
 =?utf-8?B?My93VTNzeExvZlczS0hXMy9CWHBoYWUwMmZnbHY1dzhaN2xWbVprZVhaVTZF?=
 =?utf-8?B?eHAyN01qTzhZN25xc1Q3MHJybVdsNm5pWFlhNXQ3bm1paFdESGg2WjQrZjRr?=
 =?utf-8?B?VW9pbEdWOU1BZ0JRczFHMmFFditxcGJlNkUwdWxKQXJkbU9XSnVGYUY4aFB2?=
 =?utf-8?B?cHFaaFlXYmV2cWZGZjhISHlEUXEvK1cvYjJheXRNZ0MyUW1KU2NZZmM1dHdD?=
 =?utf-8?B?ZktxTDMwY25wa280b1pMbkVXYzVlRis5QUZYdFBld1RGN2JxNTlpR2hQbkV4?=
 =?utf-8?B?QWs1WXo5ZTFzK0tuMGxtY2dRVWROdUtkeWplTjc2RkNnRWlZUWJKa2JUK2RU?=
 =?utf-8?B?ckJ6NzAvajJTM3NBcVg3VnBsUW54YUxwNlg2UExtTnJldjNoYXozbjlKbzZV?=
 =?utf-8?B?STBhSFpzVXFXN0ZGaVFKZ0NaazRLZUFiODV6TUNvdlhpL3hrKytQZG9kNzhj?=
 =?utf-8?B?NzZiQjJzU2dYYlZRQ3lyUlNXYy9US3FHVE00Y3Y2U2t1aGo5aTBvMFNXNVVx?=
 =?utf-8?B?L01QclR0TnU3VE5aS3hBUHNaMDM0SUVUYzRtTEJDV2o1TlhZUFVkNHhHU1Yv?=
 =?utf-8?B?SUFhWTZqTTBpL205YTk3MnhaVW5JZCtxQ1VWUFJwNkxKaHkzdFRpZWtpOFl0?=
 =?utf-8?B?clpQdFVGdVE0eXpQdGdwNnFRK1BQSzlnL2JHYWZuTDIrSlhVYTl4UzJiN3pD?=
 =?utf-8?B?b25oUk9mYVJqZDRUb2svWk1kSXozbm1KZW56TzRON0crRVhMdE5Ib0d6ZER4?=
 =?utf-8?B?ZlZkOVdFUHFLRWp2R1Y2SnZrMDV3YkNXWFBNZWFXeVpCcnl3cWlyMExPUjFl?=
 =?utf-8?B?K05sM3FBcFQ4Q1QrRHRiY1ZCZUM5SHRwTzB4SkdERE1hT1dFWGpWVjVRNE5I?=
 =?utf-8?B?K0FKb21HeWt6V2pmS0RpTFZMd0hYT1k0ZHlaNFpKZFFDSDFjdDhWbTlvTzZj?=
 =?utf-8?B?ZExOeCt3d1R1Q1V4QUp1Ujg5VVZBd0NDdkxFYnhLSC9ZSE5aZmdlODNxVU9s?=
 =?utf-8?Q?Sca7bCKpJob6VaJVIbFtN7wE6wpL9EcE/9jlgdp?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9512ee9e-9fc0-4864-d387-08d8f43f2868
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1783.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 12:18:57.3309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dmEUFBbKrFURho6/U4ty4yrhVJ0SrsAHiWVc9+RW6GkOy1zvG6JDSnTcu2Wm+I83Rzmm1K5b2hWopC/LpYeMO/7pWLJCjwJhP05ojbxREmo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2312
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The current sgx driver can only launch enclaves that always measure 4K pages. That may not necessarily be the case. This patch adds an ioctl to enable users to add the enclave measurement per 256 byte.

Signed-off-by: Raoul Strackx <raoul.strackx@fortanix.com>
---
 arch/x86/include/uapi/asm/sgx.h | 11 ++++++
 arch/x86/kernel/cpu/sgx/ioctl.c | 81 +++++++++++++++++++++++++++++++++++------
 2 files changed, 81 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 9034f30..121ca5f 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -27,6 +27,8 @@ enum sgx_page_flags {
 	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
 #define SGX_IOC_ENCLAVE_PROVISION \
 	_IOW(SGX_MAGIC, 0x03, struct sgx_enclave_provision)
+#define SGX_IOC_ENCLAVE_EXTEND \
+	_IOW(SGX_MAGIC, 0x04, struct sgx_enclave_extend)
 
 /**
  * struct sgx_enclave_create - parameter structure for the
@@ -57,6 +59,15 @@ struct sgx_enclave_add_pages {
 };
 
 /**
+ * struct sgx_enclave_extend - parameter structure for the
+ *                             %SGX_IOC_ENCLAVE_MEASURE ioctl
+ * @offset:	offset of the data from the start address for the data
+ */
+struct sgx_enclave_extend {
+	__u64 offset;
+};
+
+/**
  * struct sgx_enclave_init - parameter structure for the
  *                           %SGX_IOC_ENCLAVE_INIT ioctl
  * @sigstruct:	address for the SIGSTRUCT data
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 90a5caf..a21d3e7 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -261,20 +261,21 @@ static int __sgx_encl_add_page(struct sgx_encl *encl,
 	return ret ? -EIO : 0;
 }
 
-/*
- * If the caller requires measurement of the page as a proof for the content,
- * use EEXTEND to add a measurement for 256 bytes of the page. Repeat this
- * operation until the entire page is measured."
- */
-static int __sgx_encl_extend(struct sgx_encl *encl,
-			     struct sgx_epc_page *epc_page)
+static int __sgx_encl_extend_chunk(struct sgx_encl *encl,
+				   void *chunk, unsigned long size)
 {
 	unsigned long offset;
 	int ret;
+	void *secs_addr;
 
-	for (offset = 0; offset < PAGE_SIZE; offset += SGX_EEXTEND_BLOCK_SIZE) {
-		ret = __eextend(sgx_get_epc_virt_addr(encl->secs.epc_page),
-				sgx_get_epc_virt_addr(epc_page) + offset);
+	if (!size || !IS_ALIGNED(size, SGX_EEXTEND_BLOCK_SIZE)) {
+		return -EINVAL;
+	}
+
+	secs_addr = sgx_get_epc_virt_addr(encl->secs.epc_page);
+	for (offset = 0; offset < size; offset += SGX_EEXTEND_BLOCK_SIZE) {
+		ret = __eextend(secs_addr,
+				chunk + offset);
 		if (ret) {
 			if (encls_failed(ret))
 				ENCLS_WARN(ret, "EEXTEND");
@@ -286,6 +287,18 @@ static int __sgx_encl_extend(struct sgx_encl *encl,
 	return 0;
 }
 
+/*
+ * If the caller requires measurement of the page as a proof for the content,
+ * use EEXTEND to add a measurement for 256 bytes of the page. Repeat this
+ * operation until the entire page is measured."
+ */
+static int __sgx_encl_extend_page(struct sgx_encl *encl,
+			     struct sgx_epc_page *epc_page)
+{
+	void *chunk = sgx_get_epc_virt_addr(epc_page);
+	return __sgx_encl_extend_chunk(encl, chunk, PAGE_SIZE);
+}
+
 static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 			     unsigned long offset, struct sgx_secinfo *secinfo,
 			     unsigned long flags)
@@ -346,7 +359,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 	encl->secs_child_cnt++;
 
 	if (flags & SGX_PAGE_MEASURE) {
-		ret = __sgx_encl_extend(encl, epc_page);
+		ret = __sgx_encl_extend_page(encl, epc_page);
 		if (ret)
 			goto err_out;
 	}
@@ -466,6 +479,49 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 	return ret;
 }
 
+static long sgx_ioc_enclave_extend(struct sgx_encl *encl, void __user *user_arg)
+{
+	struct sgx_enclave_extend arg;
+	struct sgx_encl_page *encl_page;
+	void *chunk;
+	long ret = 0;
+
+	if (!test_bit(SGX_ENCL_CREATED, &encl->flags) ||
+	    test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
+		return -EINVAL;
+
+	if (copy_from_user(&arg, user_arg, sizeof(arg)))
+		return -EFAULT;
+
+	if (!arg.offset || !IS_ALIGNED(arg.offset, SGX_EEXTEND_BLOCK_SIZE)) {
+		pr_info("offset not a multiple of 256: %llu\n", arg.offset);
+		return -EINVAL;
+	}
+
+	encl_page = xa_load(&encl->page_array, PFN_DOWN(encl->base + arg.offset));
+
+	if (!encl_page) {
+		pr_info("enc page not found\n");
+		return -EFAULT;
+	}
+
+	mmap_read_lock(current->mm);
+	mutex_lock(&encl->lock);
+	sgx_unmark_page_reclaimable(encl_page->epc_page);
+
+	chunk = sgx_get_epc_virt_addr(encl_page->epc_page) + (arg.offset & (PAGE_SIZE - 1));
+
+	if (__sgx_encl_extend_chunk(encl, chunk, SGX_EEXTEND_BLOCK_SIZE)) {
+		pr_info("extend returned an error\n");
+		ret = -EFAULT;
+	}
+
+	sgx_mark_page_reclaimable(encl_page->epc_page);
+	mutex_unlock(&encl->lock);
+	mmap_read_unlock(current->mm);
+	return ret;
+}
+
 static int __sgx_get_key_hash(struct crypto_shash *tfm, const void *modulus,
 			      void *hash)
 {
@@ -706,6 +762,9 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	case SGX_IOC_ENCLAVE_PROVISION:
 		ret = sgx_ioc_enclave_provision(encl, (void __user *)arg);
 		break;
+	case SGX_IOC_ENCLAVE_EXTEND:
+		ret = sgx_ioc_enclave_extend(encl, (void __user *)arg);
+		break;
 	default:
 		ret = -ENOIOCTLCMD;
 		break;
-- 
2.7.4

