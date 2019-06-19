Return-Path: <SRS0=/aec=US=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE0BCC31E5B
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 15:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B77A52187F
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 15:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfFSPeU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Jun 2019 11:34:20 -0400
Received: from mga05.intel.com ([192.55.52.43]:29832 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbfFSPeU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Jun 2019 11:34:20 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 08:34:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,392,1557212400"; 
   d="scan'208";a="170595866"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga002.jf.intel.com with ESMTP; 19 Jun 2019 08:34:19 -0700
Date:   Wed, 19 Jun 2019 08:34:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, luto@kernel.org, cedric.xing@intel.com
Subject: Re: [PATCH RFC] x86/sgx: Do not increase encl->refcount for VMAs
Message-ID: <20190619153419.GE1203@linux.intel.com>
References: <20190613163008.4060-1-jarkko.sakkinen@linux.intel.com>
 <20190617164025.GA9762@linux.intel.com>
 <20190617165224.GB25085@linux.intel.com>
 <4a6512f4dff6036c4f66c1f27ce820308d5839ef.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a6512f4dff6036c4f66c1f27ce820308d5839ef.camel@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 19, 2019 at 03:46:38PM +0300, Jarkko Sakkinen wrote:
> On Mon, 2019-06-17 at 09:52 -0700, Sean Christopherson wrote:
> > On Mon, Jun 17, 2019 at 07:40:25PM +0300, Jarkko Sakkinen wrote:
> > > On Thu, Jun 13, 2019 at 07:30:07PM +0300, Jarkko Sakkinen wrote:
> > > > Since the device file stays open up until all VMAs have been closed
> > > > we do not need to increase encl->refcount for VMAs. sgx_open() will
> > > > increase it once and sgx_release() will decrease at a point where
> > > > the device file is not mapped. anymore.
> > > > 
> > > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > 
> > > Cool if I merge this one?
> > 
> > LGTM
> 
> Awesome, merged.
> 
> Sent another similar change just now for the page adder. Can you
> check that so I can merge.
> 
> I have a change in progress that will make the reclaimer also the
> reaper and remove the need for the refcount altogether. Try to
> get it possibly tonight out (i.e. daytime for you).

I'm about to disappear on vacation for two weeks, can you post whatever
you have, even if it's half baked?

I have a working patch to use mmu_notifier.release() instead of per-vma
refcounting, I'll post an RFC today.  It'd be nice to have both approaches
posted so that folks can weigh in on the options for dropping .vm_close().
