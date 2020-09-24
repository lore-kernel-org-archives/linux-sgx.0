Return-Path: <SRS0=9T+I=DB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA601C4363D
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 20:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DD9B21D91
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 20:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgIXUjI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 24 Sep 2020 16:39:08 -0400
Received: from mga03.intel.com ([134.134.136.65]:60892 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgIXUjH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 24 Sep 2020 16:39:07 -0400
IronPort-SDR: VxL8tD4VQEles6bggeKzO4aoHFLtbtJ5tyZGEJQ6FEo2GtsdjjckHsgsuSPcHrcwqxDU1Q7DkR
 +EgEnKld0Ieg==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="161411129"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="161411129"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 13:39:07 -0700
IronPort-SDR: ZfuIwYcQFblaRrHj1JX0voAtxGRxjm1+ynavquIsYsKZmRvaLxQ+DxcYtzYO0WdpzCMp1puLzk
 ZZutIy53hokA==
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="487093134"
Received: from deepamin-mobl1.gar.corp.intel.com (HELO localhost) ([10.252.44.18])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 13:39:01 -0700
Date:   Thu, 24 Sep 2020 23:38:59 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, sean.j.christopherson@intel.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 17/24] x86/sgx: ptrace() support for the SGX driver'
Message-ID: <20200924203859.GD108958@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-18-jarkko.sakkinen@linux.intel.com>
 <20200922154424.GL22660@zn.tnic>
 <20200923132037.GA5160@linux.intel.com>
 <20200923161733.GP28545@zn.tnic>
 <20200924115119.GD56811@linux.intel.com>
 <20200924155751.GJ5030@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924155751.GJ5030@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 24, 2020 at 05:57:51PM +0200, Borislav Petkov wrote:
> On Thu, Sep 24, 2020 at 02:51:28PM +0300, Jarkko Sakkinen wrote:
> > On Wed, Sep 23, 2020 at 06:17:33PM +0200, Borislav Petkov wrote:
> > > > Add 'access' implementation to vm_ops with the help of these functions.
> > > 
> > > "Add an ->access virtual MM function for accessing the enclave's memory... "
> > 
> > Thank you. I wrote the last paragraph like this:
> > 
> > "Add an '->access' virtual function for accessing the enclave's memory
> > to vm_ops by using these functions. This allows to use ptrace() with
> 
> "to vm_ops" must come after "function".
> 
> But lemme ask what is "vm_ops"?

I assume this is a rethorical question and I notice what I suggested
looks as bad as my earlier commit message :-)

So, I gave it some thought that and decided to "open code" the paragraph
as

"Add sgx_vma_access() function that implements 'access' virtual function
of struct vm_operations_struct. Use formentioned leaf instructions to
achieve read and write primitives for the enclave memory."

I think this starts to have the right balance and is understandable.

Still open for futher suggestion of course.

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
