Return-Path: <SRS0=tCn0=YJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 718B3FA372B
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Oct 2019 10:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 503A42067D
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Oct 2019 10:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfJPK3Q (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 06:29:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:44642 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726750AbfJPK3P (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 06:29:15 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 03:29:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,303,1566889200"; 
   d="scan'208";a="202036696"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.130])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Oct 2019 03:29:13 -0700
Date:   Wed, 16 Oct 2019 13:29:12 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 3/7] x86/sgx: Tweak ADD_PAGE ioctl to allow
 adding multiple pages
Message-ID: <20191016102912.GA10013@linux.intel.com>
References: <20191009044241.3591-1-sean.j.christopherson@intel.com>
 <20191009044241.3591-4-sean.j.christopherson@intel.com>
 <20191014213255.GD26869@linux.intel.com>
 <20191014213546.GE26869@linux.intel.com>
 <20191014233127.GO22962@linux.intel.com>
 <20191016101723.GA8964@linux.intel.com>
 <20191016101956.GC8964@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016101956.GC8964@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 16, 2019 at 01:19:56PM +0300, Jarkko Sakkinen wrote:
> On Wed, Oct 16, 2019 at 01:17:23PM +0300, Jarkko Sakkinen wrote:
> > On Mon, Oct 14, 2019 at 04:31:28PM -0700, Sean Christopherson wrote:
> > > I don't mind taking this to v23 review, but what do you mean by robustness
> > > in this context?
> > 
> > I think I kind of got this together API-wise:
> > 
> > #define SGX_ENCLAVE_ADD_PAGES_MEASURE 1
> > 
> > struct sgx_enclave_add_pages {
> > 	__u64 src;
> > 	__u64 offset;
> > 	__u64 length;
> > 	__u64 secinfo;
> > };
> > 
> > Length can be anything as long as low 8 bits are zero. The area
> > defined by offset and length is measured when
> > SGX_ENCLAVE_ADD_PAGES_MEASURE is set to 1.
> > 
> > I think this is the most sane API so far and does fulfill Jethro's
> > concerns why he originally wanted mrmask. I think this what most
> > users would find the most intuitive API.
> > 
> > Jethro, do you think you could live with this?
> 
> This just a version of Sean's API but with sane defaults for mrmask.

Now that mrmask is rendered out the general idea of defining continuous
regions rather than scattered arrays of descriptors is superior. And it
is also obvious that a single page ioctl would be ugly glitch even if it
wouldn't cause harm.

/Jarkko
