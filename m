Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47CD5C433E2
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Mar 2021 12:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15F6F6198F
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Mar 2021 12:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbhCaMTi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 31 Mar 2021 08:19:38 -0400
Received: from mail-mw2nam08on2110.outbound.protection.outlook.com ([40.107.101.110]:19361
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235456AbhCaMTQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 31 Mar 2021 08:19:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOrR8C9SCkRaemnJNfhYUhe8ufkKGBLFxy+X2kysTTJRUM6mjsDIbNp7vIJ9nHBxP9aHh36KE0WoJ8cS1V2BhZyj6K61SpewEZcqbIPn3LquXVuTkBZzUjBuH+7wc8L02a3lj1Bc9Xp6wAjLKIwGgFFXpRy8IGpFN9TQQcqmmPQeOcBcqAD21PUCUZQ3hVqisxfVxOHUAK8DriWXL87WAYTfVqaYOITas9G2wfKud5qFHyIHqZ6tTlIQZjSrDTx3Fabn99L0bFpmBV+o/20vmZI0NHAuWq5+LrRflKEBC4Z5KYheh4bMnmwV+wKrRJymr90KGMtEz7aEBG/HDF1+/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wVC0aWvavAiqt3LFAOxN/HSCQfX0kQ9zn8WkJtEyrD4=;
 b=aet8w0SJW/Bk+ywOLZmXgcuIPQO3dzJhdbHDsGi7fxYiOD11Hp3Aw3UD8GqbzXRMJy8ez9ext5LuVKxWtmV7CJXzlZxS7CDMAgk7qMBggAIY8gAR2w1unYXU6ZpESaJZQt7Y/fGO0ZqpQwbMrpYEiT68/0hgkBa4/cg6HwbU0AdgjrbmYQHamF4yoyMCP8IUPtg441deIu2bT21w14ar4QqnjLmMkJMTq7BMI/Hehh28zsYKPjwImfbJPQTfysDR7/6nPC3Chab7PEg2qN1hvA8E9a2gDYCRm7+bkM70ySPi/pcBE6xXrdBCGNfHCQ1xGdpL7wJVu/HnWacO2xdhZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wVC0aWvavAiqt3LFAOxN/HSCQfX0kQ9zn8WkJtEyrD4=;
 b=hUAr4aXnabfZ1ofMEAo/GfNksRx2CKf8giMS2Z0w5iSN06tPoqBPVa4pw+EY2SWtRh55no5j3haXLcZ+Ncetb8iFqZpqX1NrRlv9ex1Cmsc4IdcdNUMK/J9UWg/mczO8TquQnXZ5TOgkDADOFFL76duDO/o72g1ql/OQ7urPsiw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from CY4PR11MB1783.namprd11.prod.outlook.com (2603:10b6:903:11d::20)
 by CY4PR1101MB2312.namprd11.prod.outlook.com (2603:10b6:910:1c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.30; Wed, 31 Mar
 2021 12:18:54 +0000
Received: from CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::6dcc:f099:6ba8:6ebe]) by CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::6dcc:f099:6ba8:6ebe%10]) with mapi id 15.20.3977.035; Wed, 31 Mar
 2021 12:18:54 +0000
From:   Raoul Strackx <raoul.strackx@fortanix.com>
Subject: [PATCH 0/3] x86/sgx: eextend ioctl
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
Message-ID: <8a78055f-5159-f06c-d449-6757acb859c7@fortanix.com>
Date:   Wed, 31 Mar 2021 14:18:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.164.43.210]
X-ClientProxiedBy: AM8P191CA0003.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::8) To CY4PR11MB1783.namprd11.prod.outlook.com
 (2603:10b6:903:11d::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (81.164.43.210) by AM8P191CA0003.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Wed, 31 Mar 2021 12:18:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 097bbe79-ce40-4cd1-28aa-08d8f43f26a2
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2312:
X-Microsoft-Antispam-PRVS: <CY4PR1101MB23120F66F2FBE31C53C8DB8A8B7C9@CY4PR1101MB2312.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AVDl56JL1VEifQbAfyFVqaDJOW9AGrtVwd8ttQvh6mGa18BejzXOQeIzYpz/wbQkEfh9hEvLicNseXt16RUTVd2GiKsqFw29ggKJzc822mkhqf84mLSo/HYx6TEmKDObJwc3c/mGKp3Q86OW4htj8UxE+UjWphg1zMYFLEkpV4ItI0Dt/AjhBJZkr4q4j7bg3+roTnGILMyIgUNS+k5bCObtWlho1qhAzQDpuxR905L7xSh5fh+z8LlLS9sYn94CYMjanVPpWFi6O8f1x6CVuYaLFXQ0gFI1d9NVJywVuiSAO3iwUxi0sXGjbGs5HujmU7p7DVVl/iTj0yrcpK2pVM487xJwagnLM+3R6vDpN21rT3Q53rv/27iQ+Foo6DolfPNiovktJvtPq2DenTymHsGSynVWXZeqX3sCvrP4BaqbGWvTsTuoWolS7vIRdm8uqGmbat8eyyv/iTK38zLur5q5I0FiozOQw5PavnEuKIpQx05pKGkZI8UHBRtPfHeixaIlcRAQYpg9jDqCmOKOUi4J9yWbxfUeerIyDBlkwLZ1Eki8YZ2I6lCw2E/z3Q6Zx/MHN0QghypMsByVkzcYrYs5bJ8siJy9ow4BPqLjBMoNAyv1ObB+AC3ONFeb5x2S/2Uf8YT0/gKF9qOqyJ1yDmoekh95WcCils4Zv5OxVCvdVSt00LfvY/vkFNk/qzPrs7eJv+disGI5hCp714tndeFWvfNtOJhsuA+f83ncjIC3YA6+OkiXokU7O1DHPjuqI+dZD0BQLSOR2a2p2kuH3OojgWGzMpcNnSLligXVHBE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1783.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(396003)(39840400004)(4744005)(66946007)(2906002)(52116002)(2616005)(6486002)(5660300002)(8936002)(8676002)(956004)(36756003)(316002)(44832011)(38100700001)(66556008)(66476007)(6916009)(966005)(83380400001)(86362001)(6666004)(16576012)(186003)(26005)(478600001)(16526019)(31686004)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MDZhdDE4ODgzS1MrQ0dJMUJxWjBUOHBoMkZlSDNHU3kzcnZvNG5KTGNQYzkx?=
 =?utf-8?B?bkJLUXRxZVVzdzdNU1RuRnZLWTBheXJMZmlyZkJvdHVQMzE1WnNYeDBlalY1?=
 =?utf-8?B?QWx6bXptV3hnYS9DYWp5QzhGYzd0SnlHOHNCbnlxeXVySGFlbmlrbFgvcDdL?=
 =?utf-8?B?YkhHVnBKWVlHanJZUHkzQkh2RE03K3pKOVlhZjVDamlTRFBpRkZXeGQxR3pa?=
 =?utf-8?B?K2Y1VkZhZzBqcDNvbCtXd1k1Y2h2Z3ZESUxaVnRxdll5aENXU2tITGh5d2hy?=
 =?utf-8?B?c1VZVlpUK01YWXRzdjNZMlFGcUlHdGx4UFdpb2FpamptQmlzQ3VjUjU2Zk1Q?=
 =?utf-8?B?REV0ai8wMkhjS1lFQjZBZ1NSb3FmdlFHSHVDdjJ3MUxUTUtaVXdMWUY1L0ha?=
 =?utf-8?B?NkFCNjZGUFdta2ptL2tHOFpOYmhpUDN4enRmSHBhdFAvZExkTWtNNEd5a3hr?=
 =?utf-8?B?ZW9RcnVrMFcrZzZDbG0wMkw4bDg0TXNtM0dpZkJlcmlmN3ZWc1BZU1JBeEdG?=
 =?utf-8?B?MDNCR2s0c3pTVWttYkZYdVVaN09ydjVKVmdkK1hCVFF5aFpPeWZUUFFOM0pE?=
 =?utf-8?B?eWl2RS95R0J1Uk9CSTczNDJacjhXdzFDTjdGMkl5U2hWUko3MzBmVVpLd1p4?=
 =?utf-8?B?TFdvaURSVUUrUEl0UzJtcndXSmwyU2N2aWFwS2VXY2c4ZVFVWm5zL3ZuQ29j?=
 =?utf-8?B?c0dhc054R0dYaktlL2xVbFVaTUlEYTlJYmF2M1ZQMDkwZEpSTkhSRnVMbzlU?=
 =?utf-8?B?T01jSGduS1ZmdU9YVE92OEI2N1RzWEtPanNKL0pRb2hQaVdrUjRuMlVlMDdz?=
 =?utf-8?B?VFQwUG9xSFNJK0FkY1lRN3dJWGtTR2RCVlU5NVhZdFppVDliTEFqcXFKSDBQ?=
 =?utf-8?B?YkVRay9oV2c3Tm5mTDFsang0akNlL3lNZGtHTDlCeFZYS3BFOTZkU3FYQnJB?=
 =?utf-8?B?Si9NZExZc1NEUEVUalhNOC9JaUIzR3VwSkVSeGV5c25lbVhZSlJpd1NMVlBP?=
 =?utf-8?B?MTVFRThuV2VhL2FsZmJ3Uk1lN3JJaWs3d1Era0hqVHpMcVpUbGlxWXhPaUoy?=
 =?utf-8?B?aWExOXJmVEE3QXpzbW1FcEE1ajNENDg2RGx4bDJrSUtZcHIvakhXd2x2bHZF?=
 =?utf-8?B?TzVJLzZCZ1JpVHExaHJKb2NuMkY3U1l0WWtYekNRRDFlNVVDY1EzYVNHYzBP?=
 =?utf-8?B?bkJ3dUJyUHFiRWVsMzlNR2xQNWZZZFVNdzBjaHMxQ2dQYithZzBEcythT3Vj?=
 =?utf-8?B?Wnc5K2wxVDBmS1NPVUcrVVFyS2dWZExmWitySU42YUhuWWdkNVFLUXpldGJr?=
 =?utf-8?B?QTUzdnc4cGNZZENFTnJLU2pUR1hteS9BaytveEI1cTUvbk1sVURFQW94am53?=
 =?utf-8?B?VXh5MHBOZmoxdE0vTUxwRFlkQkNEbEVXbVhTUXExcHcxNmx4T2hOb0ZZVjJm?=
 =?utf-8?B?YkVuUlFPcVhFZGd2a1E4ZjIxVlVGWVFXL1pIZExYL0hoZGlGRlB4R3B5aGRm?=
 =?utf-8?B?b3JvcE5yaUFTME5ZMEROSDdJQkFhT2pBUUk0bE02MGZsWm4yQUxSZ1h5UUNy?=
 =?utf-8?B?aEhtaWZ4VFVrTE9GdEhIanNnT2NDM3RnZ2lWQ3BidCtqdW1EeE95SDY5Y3M3?=
 =?utf-8?B?SWs2QmZydi9vc2Ivb0dRV3pQSnZSRlU1RVdlY3JTUmFPRnBWSHVlQTE3dy9K?=
 =?utf-8?B?UjR3NUFLY2RBU2hjOHRiVEVjVTkveVFVdUxqV29HWkx6akpUMWk1OTNIbVYr?=
 =?utf-8?Q?JmSI7U6DokU6WTl9PNpnVwktFTTCc5X7Kyu8E/0?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 097bbe79-ce40-4cd1-28aa-08d8f43f26a2
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1783.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 12:18:54.2822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W3pkPCzgO1Gi9KZ71WnLHcEygh9GwlY8aStlBemZEAiOEIbC8L1tPUSqBMnbMUd9MgqJZdNR2s2Gx1cuoXPMzCtsIqib8cp/j26zk0RrIL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2312
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The sgx driver can only load enclaves whose pages are fully measured. This may exclude existing enclaves from running. This patch adds a new ioctl to measure 256 byte chunks at a time. Such a requirement has been discussed before:

https://lore.kernel.org/linux-sgx/20200220221038.GA26618@linux.intel.com/T/#m93597f53d354201e72e26d93a968f167fcdf5930

Raoul Strackx (3):
  x86/sgx: Adding eextend ioctl
  x86/sgx: Fix compatibility issue with OPENSSL < 1.1.0
  x86/sgx: eextend ioctl selftest

 arch/x86/include/uapi/asm/sgx.h         | 11 +++++
 arch/x86/kernel/cpu/sgx/ioctl.c         | 81 ++++++++++++++++++++++++++++-----
 tools/testing/selftests/sgx/defines.h   |  1 +
 tools/testing/selftests/sgx/load.c      | 55 ++++++++++++++++++----
 tools/testing/selftests/sgx/main.h      |  1 +
 tools/testing/selftests/sgx/sigstruct.c | 43 ++++++++---------
 6 files changed, 152 insertions(+), 40 deletions(-)

-- 
2.7.4

