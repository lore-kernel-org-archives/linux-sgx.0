Return-Path: <SRS0=KbJW=ZA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D52BC5DF60
	for <linux-sgx@archiver.kernel.org>; Fri,  8 Nov 2019 08:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B9A621D7F
	for <linux-sgx@archiver.kernel.org>; Fri,  8 Nov 2019 08:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfKHINf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:13:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:52402 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbfKHINe (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 8 Nov 2019 03:13:34 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 00:13:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,280,1569308400"; 
   d="scan'208";a="231974116"
Received: from rafalwi-mobl.ger.corp.intel.com (HELO localhost) ([10.252.3.149])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Nov 2019 00:13:32 -0800
Date:   Fri, 8 Nov 2019 10:13:31 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for v24 v2 4/4] x86/sgx: add @count to
 &sgx_enclave_add_pages
Message-ID: <20191108081331.GB3370@linux.intel.com>
References: <20191105112056.21452-1-jarkko.sakkinen@linux.intel.com>
 <20191105112056.21452-4-jarkko.sakkinen@linux.intel.com>
 <20191105225223.GC23297@linux.intel.com>
 <20191106232030.GA13378@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106232030.GA13378@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Nov 07, 2019 at 01:20:30AM +0200, Jarkko Sakkinen wrote:
> On Tue, Nov 05, 2019 at 02:52:23PM -0800, Sean Christopherson wrote:
> > On Tue, Nov 05, 2019 at 01:20:56PM +0200, Jarkko Sakkinen wrote:
> > > Add @count write the number of bytes added as there is not any good reason
> > > to overwrite input parameters.
> > 
> > I disagree, overwriting the params means userspace doesn't need to adjust
> > the values to restart the ioctl().  Ditto for printing out the failing
> > address if the ioctl() fails.
> 
> There is three redundant updates. At least only @length must be
> updated in order to remove this glitch.
> 
> As far as overwriting goes, it should be only done when there is
> requiring to do that.

What is obvious is that the current behaviour is wrong. You have
a *single value* to return and you encode the *same value* with
*three encodings*:

1. offset + count
2. length - count
3. src + count

And ironically none of the encodings give you the count of bytes
processed in unpacked form. It is something that must be readily
available as practically all common syscalls that can partially process
the input give that. There is a long history of that pattern and no
history at all with this weird pack of encodings.

/Jarkko
