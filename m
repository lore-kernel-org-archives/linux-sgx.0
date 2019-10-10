Return-Path: <SRS0=iuVh=YD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE8FC10F14
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 18:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CF49206A1
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 18:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfJJS4J (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Oct 2019 14:56:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:26328 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfJJS4I (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Oct 2019 14:56:08 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 11:56:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,281,1566889200"; 
   d="scan'208";a="207249846"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 10 Oct 2019 11:56:07 -0700
Date:   Thu, 10 Oct 2019 11:56:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: WARN once if EREMOVE fails when killing an
 enclave
Message-ID: <20191010185607.GE23798@linux.intel.com>
References: <20191008041334.3235-1-sean.j.christopherson@intel.com>
 <20191009000450.GA14261@linux.intel.com>
 <20191010183548.GD23798@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010183548.GD23798@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Oct 10, 2019 at 11:35:48AM -0700, Sean Christopherson wrote:
> On Wed, Oct 09, 2019 at 03:04:50AM +0300, Jarkko Sakkinen wrote:
> > On Mon, Oct 07, 2019 at 09:13:34PM -0700, Sean Christopherson wrote:
> > > WARN if EREMOVE fails when destroying an enclave.  sgx_encl_release()
> > > uses the non-WARN __sgx_free_page() when freeing pages as some pages may
> > > be in the process of being reclaimed, i.e. are owned by the reclaimer.
> > > But EREMOVE should never fail as sgx_encl_destroy() is only called when
> > > the enclave cannot have active threads, e.g. prior to EINIT and when the
> > > enclave is being released.
> > > 
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > For me this concludes that I will manually convert all the call sites
> > to use __sgx_free_page() and add appropriate warnings. I agree with
> > Borislav's conclusions here.
> 
> Argh, now we have a bunch of call sites that can silently leak EPC pages,
> and I'm seeing timeouts during testing that strongly suggest pages are
> being leaked...

Confirmed that we're leaking pages, but it's not related to the -EBUSY
case in sgx_free_page().  Debug in progress...

As to the sgx_free_page() thing, I think we can invert the old WARN logic
and make everyone happy.  I'll send a patch.
