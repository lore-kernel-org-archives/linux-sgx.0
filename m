Return-Path: <SRS0=+BDs=4F=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A5CC7619B
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Feb 2020 08:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F16420718
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Feb 2020 08:52:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="PYl+Lf+K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgBQIwg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Feb 2020 03:52:36 -0500
Received: from mail-dm6nam12on2094.outbound.protection.outlook.com ([40.107.243.94]:39420
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728217AbgBQIwf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Feb 2020 03:52:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fBUQDGLbdNqxTX7cci0Q4pzLHWCh+dIR5rvDdTg1kuaf8+umi7sLtm96gl8gY+i+B0JVLX4Sjl5FqFmeM7QQR66IQ+HcALMqK2T5vCsflDq4Akiaj8qY9mXmss2ew40ssH82bZ1l6xFy+fNeLqbBDonaJhIwX0TeJeFnC8qHvuQ+Os1T7IUSkK2e3NTgxsal676d0ucS8R6xDikCNk6rPYHXgYS1cXqA0AfByh4gtre9pUjDHo37ce817XA0vzVG4zgUgNjyyPDXqAdQCN2oo1xs4rK1e0U7mfk8YOys8dr2IisSrVMk9nvyOutxHYaryVox7eWMK98dzVA/8+ubmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Et+Hrgx7ZI2Q3fqOUro8rnvTg08rG5RdJUmN9BN8+w=;
 b=JCGS3spLSQOymhNg9TecoL1Fs8Treh93Gzp5Zpsqo/Px6t9SFLJl4aoXxbDBMHM2iLCfYP2InLHLOukYdRdO5IVLUjpBT/vHnhN4ruqHy7M3/tLZaCkUXiVgCxXuQDq/CT4iH2JTgkzpfBnyhoyRdsc+2TuGJYWi3CzDgS0v5XUhsTArTdjX+mmTBfx2SWyFFxteUir1GSgiqKklS7eImDkkRV3F9ZEIQq+UaWIPFckuya54Y507jxEP8wC2OO0ORaY5zA29N1dtANzRwpyJa9lIV/oXoY4T1cUh1DwNbR6iKGgAv6EPOw49/PFyRcx7FV8mAwG+i6LnQ6cxYgqVOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Et+Hrgx7ZI2Q3fqOUro8rnvTg08rG5RdJUmN9BN8+w=;
 b=PYl+Lf+Krm6dutjdil+EjXjMphRIAt0AnMOuRTQEAm4lPZDUd83nzcPSUXb0S8vEGlp7ip1ZuKYcvls0X/CZ4HwfJpdfnBPmZyD5fC+T6n0cQvjWjhbAYoWCDEjjyurLqC8K+w8E9IjIq43oZ8EHqxKFkC/5vpmgF1x1NOPKonE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (20.178.239.29) by
 BYAPR11MB3256.namprd11.prod.outlook.com (20.177.127.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Mon, 17 Feb 2020 08:52:32 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::180:d484:4d3f:fd99]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::180:d484:4d3f:fd99%7]) with mapi id 15.20.2729.028; Mon, 17 Feb 2020
 08:52:32 +0000
Subject: Re: x86/sgx: v23-rc2
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>
References: <20191010113745.GA12842@linux.intel.com>
 <a657081e-cdaf-7c9d-2695-23c9c07bcfbf@fortanix.com>
 <20191011181550.GB30935@linux.intel.com>
 <8dc2ab24-baf1-5e57-3906-35e7286f7ffe@fortanix.com>
 <20191017175735.GD20903@linux.intel.com>
 <eaf66973-9c9b-b06c-4b96-134e41c18d80@fortanix.com>
 <20200215072406.GA9958@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <ed49f988-e4e5-b2b9-0108-f489e9b5f449@fortanix.com>
Date:   Mon, 17 Feb 2020 09:52:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <20200215072406.GA9958@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0075.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::15) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fe::29)
MIME-Version: 1.0
Received: from [10.195.0.226] (212.61.132.179) by LO2P265CA0075.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:8::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Mon, 17 Feb 2020 08:52:30 +0000
X-Originating-IP: [212.61.132.179]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be1a00d8-76b1-4f84-62f3-08d7b386b9de
X-MS-TrafficTypeDiagnostic: BYAPR11MB3256:
X-Microsoft-Antispam-PRVS: <BYAPR11MB3256793BBA80E29FE50A7947AA160@BYAPR11MB3256.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0316567485
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(376002)(39830400003)(396003)(136003)(366004)(189003)(199004)(66946007)(966005)(4326008)(186003)(16526019)(508600001)(53546011)(31686004)(52116002)(86362001)(66476007)(316002)(4744005)(66556008)(2616005)(956004)(5660300002)(81156014)(81166006)(8676002)(8936002)(36756003)(54906003)(6916009)(31696002)(26005)(6666004)(2906002)(6486002)(16576012);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR11MB3256;H:BYAPR11MB3734.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /DSEcGAddk6HCtbpTCdmcqPxaKqQis37apbAtF15LVduK6yCPeiZzSU897l5gIe8LgdnkETF15RafoWRBbKj9GeqDXyWPXZGt/RjVs7nkZJIBNlTVgNFCZHMqaoa01LWMkppQtQcSEVJQZZwnDcYjlvqmwwT4IA7g0VIU8E3vn1BeFGmRfYs3mUqZPmr5lVJBWMv727WYJkZUa6QfsNMa4ct8VsEg13Zc7zQYp/Cy276tsMA2K2iZEl2RvJhel039g/YORmzZJaF/WDIkHdYWAqSnLMZjBfkDbiphUJkgJgciMJs7CAq1xpFpnDhbqkqIMB4u/B2V79Cg8sclD6CBMTq+6/Dp24rAUpIul9UFaUeG29ZMO4OJxNpwfm7iSVtnpkpCzFlw844EdIPmNfjUsHZ+oLmA2+QBJ6C479anjelL8AnQLHVZXzzHkpEWxEJVVkwgc5pWenE4TiMH9Yf6Ckl8oucDGeF3AuzOo9Xnuo/gdPM8mgkLkyGh4eII6kVHeTT7JM7Dq663sc0qcbi8Q==
X-MS-Exchange-AntiSpam-MessageData: buo8Xzbnmt4G/qlAPplIf4rbPf/j+7LKqU0qIPGzswovf8XGg42299mQNZwwSIODY7NDuxABeWIWHUbwFfQlJ+d9G46fGgJWrs0S1AUd6FLN0DUNiw16O9u1+j+HSQUFBTW9PEX7zy7g7Dt9jPxnxA==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be1a00d8-76b1-4f84-62f3-08d7b386b9de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2020 08:52:32.7969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ZZdLxosP6ihzS1882YsTzHZ7zsJSBi97mPWEAHBDjtQ9vah14kz0blIOB2n6hZFeLprloT2eHaISuDAKCRVgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3256
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 2020-02-15 08:24, Jarkko Sakkinen wrote:
> On Thu, Feb 13, 2020 at 03:10:24PM +0100, Jethro Beekman wrote:
>>>> There are other scenarios where it's not just the permissions on
>>>> /dev/sgx/enclave that are the problem but using the filesystem in general
>>>> that is. Maybe you've used seccomp to disable file operations, etc.
>>>
>>> Andy and Jarkko, thoughts?
>>
>> Folks, any more thoughts on how to resolve the issue that you need to
>> call open() for every enclave?
> 
> Why is it an issue?

Already discussed in https://www.spinics.net/lists/linux-sgx/msg02075.html

--
Jethro Beekman | Fortanix
