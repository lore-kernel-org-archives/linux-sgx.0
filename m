Return-Path: <SRS0=1VuV=UT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30681C43613
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jun 2019 19:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0730820665
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jun 2019 19:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbfFTTIV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Jun 2019 15:08:21 -0400
Received: from mga03.intel.com ([134.134.136.65]:15529 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbfFTTIV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Jun 2019 15:08:21 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 12:08:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,397,1557212400"; 
   d="scan'208";a="165428232"
Received: from mudigirx-mobl1.gar.corp.intel.com (HELO localhost) ([10.252.61.12])
  by orsmga006.jf.intel.com with ESMTP; 20 Jun 2019 12:08:19 -0700
Date:   Thu, 20 Jun 2019 22:08:12 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, luto@kernel.org, cedric.xing@intel.com
Subject: Re: [PATCH RFC] x86/sgx: Do not increase encl->refcount for VMAs
Message-ID: <20190620190812.GA15383@linux.intel.com>
References: <20190613163008.4060-1-jarkko.sakkinen@linux.intel.com>
 <20190617164025.GA9762@linux.intel.com>
 <20190617165224.GB25085@linux.intel.com>
 <4a6512f4dff6036c4f66c1f27ce820308d5839ef.camel@linux.intel.com>
 <20190619153419.GE1203@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619153419.GE1203@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 19, 2019 at 08:34:19AM -0700, Sean Christopherson wrote:
> > Sent another similar change just now for the page adder. Can you
> > check that so I can merge.
> > 
> > I have a change in progress that will make the reclaimer also the
> > reaper and remove the need for the refcount altogether. Try to
> > get it possibly tonight out (i.e. daytime for you).
> 
> I'm about to disappear on vacation for two weeks, can you post whatever
> you have, even if it's half baked?
> 
> I have a working patch to use mmu_notifier.release() instead of per-vma
> refcounting, I'll post an RFC today.  It'd be nice to have both approaches
> posted so that folks can weigh in on the options for dropping .vm_close().

I peeked your patch and it deals with the encl_mm->refcount. My changes
deal with the encl->refcount (consolidating the driver to only use
file's refcount).

/Jarkko
