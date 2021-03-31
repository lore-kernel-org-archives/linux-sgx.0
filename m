Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B59C433E3
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Mar 2021 12:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA703619A7
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Mar 2021 12:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235457AbhCaMTi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 31 Mar 2021 08:19:38 -0400
Received: from mail-mw2nam08on2110.outbound.protection.outlook.com ([40.107.101.110]:19361
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235461AbhCaMTT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 31 Mar 2021 08:19:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5gp67nBJb2ibyG+tCUFK+JjbGzTFS1L5TZLdEHhlN0LLIQ9Gaze2GW724CmB8SrWohyjPiygPaZxkBfaZBt06crTS2shUm01SSI536NnRSbToHXMxB/rUK/rEIefaPbShoH/elaZ7Spuj31/TbBCbOTo+V7J2T05mR6T36Vc0fnBDjQPPFZVyTEXpc+y8ccicJZDLc4RHSde4tr7sT1DvCVtL6F2tN1SAtxZ7mGyoFdkQncpGHjDDtmQSzwQGSdF7iUvO0HGlgZPNGqmJCEsbkhKXmAmmS+N+G36Q8+TDCnjZSloSerFV0XXcjOYuNG9DBlUBMt7O9Zxi5jHga/xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dV0ZY0FenLXeEWER/+oEQgXObGUTdxJ8AzO6ezD5LKE=;
 b=av9uzMduuVGaAEHXq8aMHelsb7pMO6VOlSAzFjm7/LjsFAHkS7KQwP2b2moMZptnz1/QdCONsfC3PMT3MIEnXA86oh0cmBPlF0R1gZYMt7m8oqKaReizhRhzp0pzAWG8vQwHEP0tRACqbU3zHHyU9v7Vugx5R28f/ZvXGYXxN0u/Bg4GcjUrRwAUp8bJjfDnSXOfzKB6C82LOJs7QNqxUrkwcZz/IP/mwU/T2dEooJfsUFKU1U0CSai/G1e8GVz7tEUxPAsAgPqV8XBlUFHR3amipAc4QBFwzKve7r+vJtXE0HxdDPIYKepgoCvCO/KGQMflhW9vUPshLKHZqx1atg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dV0ZY0FenLXeEWER/+oEQgXObGUTdxJ8AzO6ezD5LKE=;
 b=h0qxTdG/0gyDmW6Uie+5vDjstKWTdfHv3KD5YRxC98CTUvWA4fRsPrz+YUzo/Hz9GWuYecN78yq7RKKQ1uIbAWBKIR0r8hdYAi3Jf8WGBBHolPmn0wtGOE/VrBopTggPrkZfXNAb0JybctXtzTBXiTOEuf+PwI3OavqykKDAet4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from CY4PR11MB1783.namprd11.prod.outlook.com (2603:10b6:903:11d::20)
 by CY4PR1101MB2312.namprd11.prod.outlook.com (2603:10b6:910:1c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.30; Wed, 31 Mar
 2021 12:18:58 +0000
Received: from CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::6dcc:f099:6ba8:6ebe]) by CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::6dcc:f099:6ba8:6ebe%10]) with mapi id 15.20.3977.035; Wed, 31 Mar
 2021 12:18:58 +0000
From:   Raoul Strackx <raoul.strackx@fortanix.com>
Subject: [PATCH 2/3] x86/sgx: Fix compatibility issue with OPENSSL < 1.1.0
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
Message-ID: <88588f0a-5aa8-9ea1-8e61-6d16530dbd4a@fortanix.com>
Date:   Wed, 31 Mar 2021 14:18:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.164.43.210]
X-ClientProxiedBy: AM8P191CA0007.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::12) To CY4PR11MB1783.namprd11.prod.outlook.com
 (2603:10b6:903:11d::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (81.164.43.210) by AM8P191CA0007.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Wed, 31 Mar 2021 12:18:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d0a6599-15a4-4e7d-af5d-08d8f43f2893
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2312:
X-Microsoft-Antispam-PRVS: <CY4PR1101MB23124F165CF1FD81687804B98B7C9@CY4PR1101MB2312.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T7ZRvYnpxa3aO3SI35T2IsXvwwS0A3CZbOzJaztqqtWT97XJcdkczhxqKIP/Qxk5/25gHLvA9bdr/o3EOW+8SJ6wnZT8GShyjGyrPDJiL7j60MTnDb4K+XoOZ0gfB79+S3YEXuFApRGD9SzvsNBZcUYMd3mTmEsGpksrWiyEtF/e8su4fAZJHeb3MNRByMeAT7pTDSmikfqFKbwocbmOI1D52h64unSMuzDfxxA9nST0gVFQBumPEH/Aco2l3Nagr86y0gT+M85nL4PUyz7l/hwQEQ9P/PQmYix699+Uyfk4rHghsOn5fMXJy69hJDNRxojc2QdaSLBCSEFeTcRqn59FghGxMKgzu4cFQISzOnoC8KYpJr2fU76MQvZTVaZ7zwMRo8MrH6+zAz8X6s3Buqpb9mYH/Kd10WGVBoV82ULLQS9/bkdAcAiBoVpVjSWm1tStSgrk2YROQ346yIKl9NwKiC1dxEIHHwTFHZUAZi9FAkVEHTtaITq+2k5XK2dw2QI2CJNGeGEOAuLsiV8LZ0PyoRlZdgH5GHpU5jdwfcscIcSrkyF9AKjvPgFuMtS2dlRG22lUwU0a7cBX1VvvyQUMYbrH1Lr368Io9hf84a3tzJAqHLAell4N2ApwrKaZx3pwJc9B5coawCjE94336d4htbQUdqjfSy/E8t4F8l3s2H2tpbtTSTCTHNh4GJ2Sf6f+FmJWVc0+NW8MSVqbGvPi8EahkI7najCFjvxN2GQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1783.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(396003)(39840400004)(4744005)(66946007)(2906002)(52116002)(2616005)(6486002)(5660300002)(8936002)(8676002)(956004)(36756003)(316002)(44832011)(38100700001)(66556008)(66476007)(6916009)(83380400001)(86362001)(6666004)(16576012)(186003)(26005)(478600001)(16526019)(31686004)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bk1YVFNSWHFNY1Eya09LbHRyYVF2Y2MvcnNnT3lPVmVrOUdlbWgwUGgzNDkv?=
 =?utf-8?B?WUlMUGU1ZVFnT0h5UldaVkJFcGozMWM1aWk4Q1hWeFR1bEZBNklGOG5rNzdy?=
 =?utf-8?B?TTQ2WTNuQXV5RG8vZGJYZG81TVYxWHhtOXRMTEhSOFFUc0FqTHUzbGEvVlJU?=
 =?utf-8?B?NGZSaG9ZcWg5ZzBGSFlyWjI3UndEaWFPOFBoWGdlc1pEVkdXYkFpVEU0enpF?=
 =?utf-8?B?dnZCRkx5TTZsN2FPRUYwT2QxUGtmVHlhSVRWQUlYdTNOdmpESTNaZEJJYUtZ?=
 =?utf-8?B?ZHQwQktIY2haRWJaZ3ZLQTBpQXJtbVVOYm1yMGVvT3FsSUV3dWNtZ2pvbzJv?=
 =?utf-8?B?NnFiR2M2alZnUVBNOXI1QnNYTlllY2tibTl5TmNBY3hIb3ZvRWx6UEdNZWpV?=
 =?utf-8?B?ZWJ0aFNNdHJxNHpjQmliN3RkOUxTbzFpNU5ncXpxcmFyWjNiMm9SVzllcGgz?=
 =?utf-8?B?UVRZc29TWVJ4ejh0bW1mUk02aWlDTW1wdnJwSERSTmNHbUNhUDZiUlZodlcr?=
 =?utf-8?B?TXk0QlE4Myt6Sjc2bGN5dk1aVE9lN2VUQnZiOS9YNWVRbVRvYW1xRWc4c1RQ?=
 =?utf-8?B?NEwvamJkSlZBSFY4K3pKNzNXRkl2anpkeXJmcTZFM0NTam55VDUva0p2dTVK?=
 =?utf-8?B?QmtKTzQzQnRZNGhTRkg5d1hCY2Zuc0NoQ25MRXN6UXh2QWg5REJPTnNJZmZB?=
 =?utf-8?B?SGdzUW93NEpUS3FMMlQ3bTFWdlVqdTdRYWZhMWR1TUZ6R1o5OGIyYlF3Qnp4?=
 =?utf-8?B?Q3MyTmhvTkFXQWRMdkkxZm1oYWp1TXE0aG9oRmhrclI1RlJYUmFJMzY5eHZo?=
 =?utf-8?B?WDRpWVRCUWZHUXJhQXhhODhxaSt0MHFScDV5VzZxcmpiUDV5S2xIUFJadXgw?=
 =?utf-8?B?bGowM2M2MGVST2tjSTNFOXpVbFNNRXFqRUVwR0pvWDkzUlpRUUMvY09TSEEv?=
 =?utf-8?B?SFd2U1I1OUpBdkNveGljU2drVjVtMFAwaENRRTdlMHF4bE55M2t2SWxtZkdn?=
 =?utf-8?B?aXQzNkszcUNwVCtySVdBbXlCRWM0aHo5dW5qc0VOd1lLM0pFRjlmekJFTlAr?=
 =?utf-8?B?eUd6NVoxTGJuSlZuY2NkemJtUnZWaHZFbVBTQXFWVDFtaDRXK1ZkR05SSGlW?=
 =?utf-8?B?QTVtZ1RoTzhaOVhIdmVTMlhRd21Sby96dWd6Y0VsTlVucXc4cmlScUcrTTEw?=
 =?utf-8?B?a25QNEZyTHRnd041YThtUGNVdWVzTnpDNnRTM01RVFBiR1dVMnV2M2RJK2di?=
 =?utf-8?B?TjFpcUdOTWFYTUJ0dGpDWHI4NWM2L0Y3WjB2STZOcGd1UUN6YVFsWlh0Y2k4?=
 =?utf-8?B?VzVxV2Y5dlkzeHNqSG54VFRzcDUycEpuWDdEdTVybkVHeTZuazhDQlpJMkVi?=
 =?utf-8?B?b1pvUzNtRlBzcENoRW02MVRqdlhUT1kweGVrNW13cFB1L1hUSkxtRGlsb1FV?=
 =?utf-8?B?dk9JTlR5cVQwenlFSE4vbGtNY29IT0FTOVUrTCt0MXJNNm54c2NBT3owakcr?=
 =?utf-8?B?WE9Sc0g2bW5BWkRCak05YjlueDNvNmlnR0RkcW41VFBZR2JncTlEUmZRQjJu?=
 =?utf-8?B?RFpwZUM2MTI2YzNLaVVMVkVxTWZnaURhdGMxL2VZRXZoejlkM3lZaDVCT1Q0?=
 =?utf-8?B?dWJCNXd1WTZWek1FN2t3QUZ2WERmQStuOE9VZ3FtS2dxd3hqZkpDVFZKT2Zp?=
 =?utf-8?B?RkN6V1JEVkJSYm9GSTdIL3hUQUtiTnZ1cEpJRzhlczA1a3NDbkg2bW45MlRG?=
 =?utf-8?Q?/G2e0xLk9sr7mN5Hs5ozsuUTuqZftak2mGciMBY?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d0a6599-15a4-4e7d-af5d-08d8f43f2893
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1783.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 12:18:57.4739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cCGTB2rlSFK05UxBze5RE8z0QN/QTHLOPsasDX4+6twCghDJiGlhj6vttMDa1+xnMboGXkNh1NFzqb+OkAK/KxFWAC/MWtiKfP2SRwJNPZM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2312
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The `RSA_get0_key` function only got introduced in OpenSSL 1.1.0. This makes compilation fail with older versions.

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

