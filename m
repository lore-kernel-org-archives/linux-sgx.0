Return-Path: <SRS0=T+5Q=YO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E23DFCA9EAF
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Oct 2019 11:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3BF42089C
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Oct 2019 11:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbfJULZD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 21 Oct 2019 07:25:03 -0400
Received: from mga18.intel.com ([134.134.136.126]:2805 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727433AbfJULZD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 21 Oct 2019 07:25:03 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 04:25:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,323,1566889200"; 
   d="scan'208";a="196081510"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.130])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 04:24:59 -0700
Date:   Mon, 21 Oct 2019 14:24:58 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 3/7] x86/sgx: Tweak ADD_PAGE ioctl to allow
 adding multiple pages
Message-ID: <20191021112458.GA11086@linux.intel.com>
References: <20191009044241.3591-1-sean.j.christopherson@intel.com>
 <20191009044241.3591-4-sean.j.christopherson@intel.com>
 <20191014213255.GD26869@linux.intel.com>
 <20191014213546.GE26869@linux.intel.com>
 <20191014233127.GO22962@linux.intel.com>
 <20191016101723.GA8964@linux.intel.com>
 <20191016101956.GC8964@linux.intel.com>
 <20191016102912.GA10013@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016102912.GA10013@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 16, 2019 at 01:29:12PM +0300, Jarkko Sakkinen wrote:
> On Wed, Oct 16, 2019 at 01:19:56PM +0300, Jarkko Sakkinen wrote:
> > On Wed, Oct 16, 2019 at 01:17:23PM +0300, Jarkko Sakkinen wrote:
> > > On Mon, Oct 14, 2019 at 04:31:28PM -0700, Sean Christopherson wrote:
> > > > I don't mind taking this to v23 review, but what do you mean by robustness
> > > > in this context?
> > > 
> > > I think I kind of got this together API-wise:
> > > 
> > > #define SGX_ENCLAVE_ADD_PAGES_MEASURE 1
> > > 
> > > struct sgx_enclave_add_pages {
> > > 	__u64 src;
> > > 	__u64 offset;
> > > 	__u64 length;
> > > 	__u64 secinfo;
> > > };

Offset would be split as 48:8:8 aka PAGE_INDEX:MRSTART:FLAGS
Length would be split as 48:8:8 aka NR_PAGES:MREND:0

Forgot from my earlier description that measurement starting
point would better to be also after the page start but with
this bit presentation everything can be cleanly described.

/Jarkko
