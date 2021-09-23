Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7665EC433F5
	for <linux-sgx@archiver.kernel.org>; Thu, 23 Sep 2021 22:11:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 512B661242
	for <linux-sgx@archiver.kernel.org>; Thu, 23 Sep 2021 22:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235578AbhIWWMv convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 23 Sep 2021 18:12:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:36316 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232145AbhIWWMu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 23 Sep 2021 18:12:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10116"; a="223980484"
X-IronPort-AV: E=Sophos;i="5.85,317,1624345200"; 
   d="scan'208";a="223980484"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2021 15:11:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,317,1624345200"; 
   d="scan'208";a="551322250"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Sep 2021 15:11:17 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 23 Sep 2021 15:11:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 23 Sep 2021 15:11:16 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2242.012;
 Thu, 23 Sep 2021 15:11:16 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     "Luck, Tony" <tony.luck@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
CC:     Sean Christopherson <seanjc@google.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Subject: RE: [PATCH v6 1/7] x86/sgx: Provide indication of life-cycle of EPC
 pages
Thread-Topic: [PATCH v6 1/7] x86/sgx: Provide indication of life-cycle of EPC
 pages
Thread-Index: AQHXr96q6UEJIdR3e0mYtME4Cszq46uyhucAgAAAwID//5CrAIAAFrww
Date:   Thu, 23 Sep 2021 22:11:16 +0000
Message-ID: <fe8b68dd183b4350bb9c5372d587899b@intel.com>
References: <20210917213836.175138-1-tony.luck@intel.com>
 <20210922182123.200105-1-tony.luck@intel.com>
 <20210922182123.200105-2-tony.luck@intel.com>
 <5aa9e385b38ce0f63d6b531ede2baafd17fc7861.camel@kernel.org>
 <42f4b668b5abe818295d804d43c077e5d3cb4a4c.camel@kernel.org>
 <YUznjYO0TZuorE/2@agluck-desk2.amr.corp.intel.com>
In-Reply-To: <YUznjYO0TZuorE/2@agluck-desk2.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> That's nice. It avoids having to create a fictitious owner for
> the dirty pages, and for the sgx_alloc_va_page() case. Which
> in turn means that the owner field in struct sgx_epc_page can
> remain as "struct sgx_encl_page *owner;" (neatly avoiding DaveH's
> request that it be an anonymous union of all the possible types,
> because it is back to just being one type).
>
> Thanks!  Will include in next version.

Also avoids a bunch of refactoring to make sure to set the owner field
while holding zone->lock.

I roughly coded it up and the old part 0001 was:

 arch/x86/kernel/cpu/sgx/encl.c  |    5 +++--
 arch/x86/kernel/cpu/sgx/encl.h  |    2 +-
 arch/x86/kernel/cpu/sgx/ioctl.c |    2 +-
 arch/x86/kernel/cpu/sgx/main.c  |   21 +++++++++++----------
 arch/x86/kernel/cpu/sgx/sgx.h   |    4 ++--
 5 files changed, 18 insertions(+), 16 deletions(-)

which is by no means huge, but the new part 0001 is

 arch/x86/kernel/cpu/sgx/main.c |    4 +++-
 arch/x86/kernel/cpu/sgx/sgx.h  |    3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

-Tony
