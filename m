Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67152C3A5A1
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 14:55:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A5FF2133F
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 14:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388069AbfHVOzl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 10:55:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:48013 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732015AbfHVOzk (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 10:55:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 07:55:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,417,1559545200"; 
   d="scan'208";a="208194070"
Received: from greathea-mobl2.ger.corp.intel.com ([10.252.39.37])
  by fmsmga002.fm.intel.com with ESMTP; 22 Aug 2019 07:55:39 -0700
Message-ID: <8fb904130d8e64b4ef5af4a99fce15a6b4351d8a.camel@linux.intel.com>
Subject: Re: [PATCH 2/2] x86/sgx: Determine SECS at compile time in
 sgx_encl_eldu()
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Date:   Thu, 22 Aug 2019 17:55:38 +0300
In-Reply-To: <20190822005551.GP29345@linux.intel.com>
References: <20190821232902.29476-1-jarkko.sakkinen@linux.intel.com>
         <20190821232902.29476-3-jarkko.sakkinen@linux.intel.com>
         <20190822005551.GP29345@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2019-08-21 at 17:55 -0700, Sean Christopherson wrote:
> On Thu, Aug 22, 2019 at 02:29:02AM +0300, Jarkko Sakkinen wrote:
> > Using address resolution of any kind is obviously an overkill for
> > anything that we know at compile time. Those sites should not hard
> > bind how we store SECS.
> > 
> > This commit adds @secs_child to sgx_encl_eldu() and sgx_encl_ewb()
> > and replaces sgx_encl_get_index() with a macro SGX_ENCL_PAGE_INDEX()
> 
> Why use a macro instead of an inline function?

Just for consistency and nothing else.

It falls into same category as the two other macros in encl.h:
unconditionally give attributes of the page with some calculation
appied (the earlier function had a real flow).

We could consider separately converting all of the three as inline
functions though (not in the context of this patch).

> Rather than pass a bool, we can pass 'struct sgx_epc_page *parent_secs'.
> That'd avoid having to name a bool, and would clean up this type of code.
> In general, I dislike boolean parameters where the caller uses true/false
> as I can never remember the context of true/false.

Sure, but why not just @secs? It is always a parent.

/Jarkko

