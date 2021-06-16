Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0612AC48BDF
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Jun 2021 00:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C485F611CE
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Jun 2021 00:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFPAbI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Jun 2021 20:31:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:53982 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230244AbhFPAbI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 15 Jun 2021 20:31:08 -0400
IronPort-SDR: +YgqZMhHg8/2c3KcXM5+XJcwC4SYxzwrtyAAzXOEO+VzletepwPYb0hXtUF2wPjmG2URB1TYAf
 J5MmFqz5HpTg==
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="206048997"
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="206048997"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 17:29:02 -0700
IronPort-SDR: oq76LDfEY1PUZ0mYpQP6e4zRDQbAYFogbgYwthtjbTyRFJ3GGBbXZVSUSsL9EGMIO/X5MuKpl4
 3zaFr6+cml2Q==
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="553861918"
Received: from shyvonen-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.5.121])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 17:28:59 -0700
Message-ID: <84b136e7368a982c80dc344b17eb992ea73a0896.camel@intel.com>
Subject: Re: [PATCH] x86/sgx: Add missing xa_destroy() when virtual EPC is
 destroyed
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, bp@alien8.de, seanjc@google.com,
        jarkko@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        Yang Zhong <yang.zhong@intel.com>
Date:   Wed, 16 Jun 2021 12:28:57 +1200
In-Reply-To: <89b29a2b-0050-cef4-8bf7-0b3bc2f5c170@intel.com>
References: <20210615101639.291929-1-kai.huang@intel.com>
         <89b29a2b-0050-cef4-8bf7-0b3bc2f5c170@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 2021-06-15 at 08:39 -0700, Dave Hansen wrote:
> On 6/15/21 3:16 AM, Kai Huang wrote:
> > xa_destroy() needs to be called to destroy virtual EPC's page arra
> > before calling kfree() to free the virtual EPC.  Currently it is not
> > calaled.  Add the missing xa_destroy() to fix.
> 
> Looks good Kai, thanks for fixing this.
> 
> Could you please take a good look through the sgx_release() and the vpec
> equivalent and see if anything else stands out as possibly being missed?

I looked over.  One potential issue is both sgx_encl and sgx_vepc have 'struct mutex lock'
embedded,  but mutex_destroy() is not called when they are released.  However I am not
sure whether this is worth fixing, since mutex_destroy() is empty unless
CONFIG_DEBUG_MUTEXES is turned on (even with it turned on, mutex_destroy() doesn't do
anything like freeing resources so in practice there should have no problem).

Another thing is sgx_encl_release() doesn't explicitly call xa_erase() for each EPC page
in encl->page_array when looping it over to free all EPC pages, but I think it is OK since
xa_destroy() is called later which will destroy all xarray internal data structures.  But
I don't know internal implementation of xarray.

>  Also, is this the kind of thing that a simple open/add/close selftest
> might have found?

It might be useful but I don't think it can detect things like xa_destroy() being missing.

> 
> Maybe we should beef up the selftests a bit.
> 
> Acked-by: Dave Hansen <dave.hansen@intel.com>

Thank you!


