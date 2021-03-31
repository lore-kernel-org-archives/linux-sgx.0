Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF16EC433E0
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Mar 2021 12:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 970EB61957
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Mar 2021 12:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235450AbhCaMTh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 31 Mar 2021 08:19:37 -0400
Received: from mail-mw2nam08on2110.outbound.protection.outlook.com ([40.107.101.110]:19361
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235457AbhCaMTS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 31 Mar 2021 08:19:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6fRqXfE12vX8LSEsPig5IrGZLVo9aHiW6imRstfQPXio8idB8hzNXcSaVUAp8Jc5LwRROOUbVAXlAK3395C/kqQC/6dQh/6MZ/f+Abwp56qNEIB4HqiaExovuI/eQqLNkU5WQSbDoyTPvhYT57hXR3+UPzLCP0gsJrCsUnD6kMjicI6HCabwcGCOCdMtfBy1xyTWHMRXINyk5TrzcUzC2uc2C3uRk/COD/VDFE6XAnrW69+q1iVgNZwn7deVUqeUfFry9uZOZY3LeAo0QftEJKrC6jnYuB9InRzb7YfimH96Vci7KQjZkl/HV/1orC5x2U7fA0pthDqUNjYyq3p/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sn0/WsafaTrgS1iuYWiKLeoO90R7Il7zyL18dwiDe8Y=;
 b=P4hp1yCVPDwxo0BOap3ha63irSDXyjfrr3Pm4BQqk/rIxokGJULv4GqA83C6/Y+E3fbREdyp83noCMZ22WrN1vjyMJcrEG/XoXgyMmyU39gjMWxAKk5F30+iQE1NA5BtGRvZLl67WCX+D6wYVJNXAnvCiXYBUQgUAn6rKiIsDlbCttFg904hkXGkQjKEBMDk6HNncmjH9waQ9rYr7F7cMB8ForuXTP32gkpb7ddJkCbMq4E4DOyW/rTYvFmoihOPqgr3cOoTv0zzMcEVFVg7OGi0KA6vHwqcyHKZ4TrpLX6Z+Mfs8C4xroahf5HnUrQDWjVu/F9VfLhQMocF+o5uBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sn0/WsafaTrgS1iuYWiKLeoO90R7Il7zyL18dwiDe8Y=;
 b=ioDFpd1IMyJA4WuuekLY890B3JUa4dkO9NBZ//7hLUOxdmxJ1NSXolVvj9q/MlocDrBoYCfCxREKNYNEPgJlAUPbZhKxQLUdBs8yssQUt15mP/mD3Xp2DAq0HXs1cVxL0XDybeyQzvM+UAYTvY8Yg3hVoPwx0HCTSP516jIOOQo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from CY4PR11MB1783.namprd11.prod.outlook.com (2603:10b6:903:11d::20)
 by CY4PR1101MB2312.namprd11.prod.outlook.com (2603:10b6:910:1c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.30; Wed, 31 Mar
 2021 12:19:00 +0000
Received: from CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::6dcc:f099:6ba8:6ebe]) by CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::6dcc:f099:6ba8:6ebe%10]) with mapi id 15.20.3977.035; Wed, 31 Mar
 2021 12:19:00 +0000
From:   Raoul Strackx <raoul.strackx@fortanix.com>
Subject: [PATCH 3/3] x86/sgx: eextend ioctl selftest
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
Message-ID: <6cae4ec0-899a-5ae2-353a-d5877296aa72@fortanix.com>
Date:   Wed, 31 Mar 2021 14:18:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.164.43.210]
X-ClientProxiedBy: AM8P191CA0019.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::24) To CY4PR11MB1783.namprd11.prod.outlook.com
 (2603:10b6:903:11d::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (81.164.43.210) by AM8P191CA0019.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 31 Mar 2021 12:19:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0e3ed4b-9d03-4dec-d6dc-08d8f43f2a7a
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2312:
X-Microsoft-Antispam-PRVS: <CY4PR1101MB2312873576B67F81BCE737A88B7C9@CY4PR1101MB2312.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qNGO9I/sKBtSDyVQGcP6M1Nfi0iG3kapiXZ8+KDW0TJuXeD9ee0+8SSb1PmeRyMC/RutzgyJnz1eBkuY046dqA8A0XsdwCpE/ki5JrF87rxgexHGIJTgapTWDFeDRMGLF50U22sHJifxjHmCGgwa9wJ/Xej7wXbXiWJ5tp9YALIXlWI4dMu4EWMHkUbRkWrvV3ZqStMkKXTfOP88M+p7KUsCgQUC0XC0TtXzfLm7vgIlOE/T8wxBKr3A2RIJ3Zo3SOs1cNWfzDAuFSXXEu1F2j/j9DrKd7bcFDZl53oDkLpymWYzLx/ujcF1uecB05aBJm13Jfc+C53e5m7+8RH87upgJSYOxWrULS6POYJ/BOOUkHVf/+4f8d/KhPE4DobUgXYyCsNuAUC+PVQgzymVCcJF95DEa1o5YOaLdmgLAUyPnbJa1xxAL1mBs3aqlsyoiGVaTkATM4AvIdcS0DplZhwcKQ6+bJP9sMfcfhelIw/u5NL/+36pdljpeA5Ar0hbgexwlqmgSWP0n1egIb1Dk4welETo+Rtsbub7zm6CkUIOsGrye8WPf6xvlQrPRj0exc9hk20PeoW00mOtX1PZncIqYqtfGoHO9CT/rrJ0NNlPN/b7vDgmzjUIlyP3+j1gdwB5ak7AhKwzNvkvJe6wrboONMkLTbW2lRCfSwrOpHzsobv2XfkxND6LAQ068whSdmblk6SZMIZM95ASvjy0dVgyKZv154/RgtpNcKx4NYs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1783.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(396003)(39840400004)(66946007)(2906002)(52116002)(2616005)(6486002)(5660300002)(8936002)(8676002)(956004)(36756003)(316002)(44832011)(38100700001)(66556008)(66476007)(6916009)(83380400001)(86362001)(6666004)(16576012)(186003)(26005)(478600001)(16526019)(31686004)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dC9PZ0lqMW1UYitiQlVVM0taV2lXb0Q4THV0N1BNRjM0cHJiTmE3cExUOEx3?=
 =?utf-8?B?eGdZazU2KzZYUUM0czk3dU8vSk9sSmtEV1h2cjkya251dkNxSmZKUXluazFo?=
 =?utf-8?B?NU1Sb2lSTEZ1M1NyR2ZnakxSZXQ4RnV5WXB1U2RNcHhJdmpMZjQ2VloxM1BY?=
 =?utf-8?B?VUxoZ0crOUliY2taTFFFenRMeHN6QkRjd1ROQmt5TFBzQ2NIaDZ1d0tyRFd3?=
 =?utf-8?B?NmVXQ1ByV1QxR2RZMzFmYlhUWThsaXRFLy90SXFkdVRoMWkxQy8yK3Q3enEr?=
 =?utf-8?B?djlCTS9PWHNPaUFmYi9QN1djZWxNV2Uzd3lobEZOQlQveU0rRENoeWtqbTV3?=
 =?utf-8?B?ZFZYaHVoTmRDSlQ0a2Fid3FYZGFycVhIdFVoNldBVDhEazJoS2ZJR3RjT1pt?=
 =?utf-8?B?UDJZUUNWc2pOK1FGVzhveVBjSGptMWdFZXdVU2JVeENqNjlqNENRSHdFZi9B?=
 =?utf-8?B?cWxMVis1Wi9Oamxlc3FFQms1N3U0UU12K05EZDRWdUFyN3pWMjRZV090dUFh?=
 =?utf-8?B?OEVJWUo5NE9ERFd0UXY0SWFpdWxzakFvUlJUK0pPemdKdGcyOEtyZWhoUktq?=
 =?utf-8?B?dG9aaW1uc0x0RnIwNG0wNitGNmxhdFJPZHkvTDdENlBtMUlWOFZaOUIxTnJm?=
 =?utf-8?B?OEpPN2pUNWVXdU0wbElxUnRqNS9UQ0xkeStVWjF2aDdFOC9aZ3V2MjJHSTdT?=
 =?utf-8?B?c1FGMVpDVzZhbm92LzFaZTNPSkxITjU3SHR3RmJiUzBSTCsyZ09pUHZkZVBX?=
 =?utf-8?B?RUFWbGppeTdORFFHdzh1QytFZzNsV1hhSUd5bjNnRVUvSGZZQmxvcElhNVFY?=
 =?utf-8?B?N2lBQmR2MnJ1OHg5aEg5SGQyU0hEK2FPaW1EZGxnRms3MlM2dHlpWVJ1OTlK?=
 =?utf-8?B?d1pLMlo1VWZQYXc0V2JhZVk5bnlaaytWaWlpM0NxT0R1SEVBQTVDRXQ3VnFj?=
 =?utf-8?B?RkJUckZJcm53UGFKM2l2dU5FcDhteUdYaEFzUVVVS2FZS3BjT0dqTisyRXRO?=
 =?utf-8?B?SFpHVmRpNXlFVEhJRGpDWlIzSmloRDlEU0hRb2RKcGs1VTVBRWFzeENDdFBa?=
 =?utf-8?B?YmVjTjRLQkRaODVYTWlXU2lIRDVIV2ZtbEJCeksycXJabkRZSGJkVlFiMWtE?=
 =?utf-8?B?cm85K1lTbmlHN3JBRmRBL3F6YWhZMzFkRnY4U1QrS0hzMnNVVkdpL3pIYnF6?=
 =?utf-8?B?eklhbmFzdHcrWXh2aTdIaUFoMWVzWUZkOEE3aCtGZnpuU3piTzFHOFgrRVV5?=
 =?utf-8?B?cko4NVZOTktDaUxHYkw2aTNGVm5MbjhhUGFZbU9FbkFJZFY0SnFQRHkyMEwv?=
 =?utf-8?B?dklnZlNiMVp4d2dKUTRUazhJalpzODhoeTNWQ1BoTHp2c3owRmQ2a2pkOC91?=
 =?utf-8?B?WFhNaXArVGd5cjRNUENyekRvRzVRYnZadE5zQ2VSazA0Z1gwY0d2VFVZeDgz?=
 =?utf-8?B?ZUVqNTk3cTM0MUtnaUdOOXZNM0dkZ0VwTFk4dXBZZDBGM1lnNlpURnZSVFVN?=
 =?utf-8?B?R0lMcnZFU3VFdWVpY3FKdncvUGVuSFc0Qy95bWhBR2ZteVZmdnVlaU5KU0R0?=
 =?utf-8?B?SHA3Wk9VY3owVUp5anp5RFVFTkJpRTBGVkNISFExQUxnazlzMG85bVExdnJo?=
 =?utf-8?B?ay9Lc0M4M25pOHNKNXA4cGhKRnUyTWZOdXltckF3N09oMS9rRnFNZTF1QWVR?=
 =?utf-8?B?VjgwSURUMHFKQ2NXUjdXektnZENJWWxibFNuWitQbGJyVXIxOXIvYkZOTWs5?=
 =?utf-8?Q?tQWYTnY6/ms/ohPgG4dYyqfhGSpW2qEZWu1sBs9?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0e3ed4b-9d03-4dec-d6dc-08d8f43f2a7a
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1783.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 12:19:00.8004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jcD46PPP/w/i54i1vn8IIzUEiMo9/zo6aTv9Q7WwXRxHAoe/k6qTApIBL11fstjuwS1H2QZ1N4PVW7/A5cUE1utq+OWQuxojbZWPXEhoq30=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2312
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

