Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B324C12002
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Jul 2021 23:39:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0762D613C8
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Jul 2021 23:39:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235738AbhGNXlz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:41:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:12240 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229535AbhGNXlz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 14 Jul 2021 19:41:55 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10045"; a="197629552"
X-IronPort-AV: E=Sophos;i="5.84,240,1620716400"; 
   d="scan'208";a="197629552"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2021 16:39:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,240,1620716400"; 
   d="scan'208";a="562601991"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga004.jf.intel.com with ESMTP; 14 Jul 2021 16:39:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 14 Jul 2021 16:39:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 14 Jul 2021 16:39:01 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2242.010;
 Wed, 14 Jul 2021 16:39:01 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>
CC:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/4] x86/sgx: Track phase and type of SGX EPC pages
Thread-Topic: [PATCH 1/4] x86/sgx: Track phase and type of SGX EPC pages
Thread-Index: AQHXdCUcDncuRnkx9Ue+ht5iNpTdPatDbnyA//+NavCAAH2fgIAAHc8A//+QpcA=
Date:   Wed, 14 Jul 2021 23:39:01 +0000
Message-ID: <c0fa2e9e65da4f58893386279ce914c1@intel.com>
References: <20210708181423.1312359-1-tony.luck@intel.com>
 <20210708181423.1312359-2-tony.luck@intel.com>
 <93845f78-120d-7522-bd3e-fe042380d29e@intel.com>
 <31668f36583844cbbae0b10a594193d6@intel.com>
 <00114991-9075-84f4-797d-f0f953d34660@intel.com>
 <YO9uZKLYCIBc1HsH@google.com>
In-Reply-To: <YO9uZKLYCIBc1HsH@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> I've no objection to tracking the type for SGX2, my argument in the context of
> #MC support is that there should be no need to track the type.  Either the #MC
> is recoverable or it isn't, and the enclave is toast regardless of what type of
> page hit the #MC.

I'll separate the "phase" from the "type".

Here phase is used for the life-cycle of EPC pages:

DIRTY -> FREE -> IN-USE -> DIRTY

Errors can be reported by memory controller page scrubbers
for pages that are not "IN-USE" ... and the recovery action is
just to make sure that they are never allocated.

When a page is IN-USE ... it has a "type". I currently
only have a way to inject errors into SGX_PAGE_TYPE_REG
pages. That means initial recovery code is going to focus on
those since that is all I can test. But I'll try not to special case
them as far as possible.

-Tony
