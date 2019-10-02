Return-Path: <SRS0=237/=X3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 785ECC4360C
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Oct 2019 23:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5731221848
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Oct 2019 23:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbfJBXm7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 2 Oct 2019 19:42:59 -0400
Received: from mga17.intel.com ([192.55.52.151]:25600 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727613AbfJBXm6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 2 Oct 2019 19:42:58 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:42:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="275520079"
Received: from tanabarr-mobl2.ger.corp.intel.com (HELO localhost) ([10.251.95.47])
  by orsmga001.jf.intel.com with ESMTP; 02 Oct 2019 16:42:48 -0700
Date:   Thu, 3 Oct 2019 02:42:47 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        "Xing, Cedric" <cedric.xing@intel.com>
Subject: Re: [PATCH v22 00/24] Intel SGX foundations
Message-ID: <20191002234247.GA16314@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <eed916f3-73e1-2695-4cd1-0b252ac9b553@intel.com>
 <20190914134136.GG9560@linux.intel.com>
 <8339d3c0-8e80-9cd5-948e-47733f7c29b7@intel.com>
 <20190916052349.GA4556@linux.intel.com>
 <CALCETrWDLX68Vi4=9Dicq9ATmJ5mv36bzrc02heNYaHaBeWumQ@mail.gmail.com>
 <20190925143204.GE19638@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925143204.GE19638@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 25, 2019 at 05:32:04PM +0300, Jarkko Sakkinen wrote:
> On Tue, Sep 24, 2019 at 10:20:09AM -0700, Andy Lutomirski wrote:
> > > I think either can be considered post-upstreaming.
> > 
> > Indeed, as long as the overall API is actually compatible with these
> > types of restrictions.
> 
> I include LSM changes to the follow up versions of the patch set.  This
> is done to help verify that the API is compatible (or make it easy to
> review).
> 
> I think they should be merged only after SGX is in the upstream beause
> this will make testing and reviewing smaller details of the changes less
> edgy the for LSM maintainers when one can just grab the LSM changes and
> try them out with the mainline.

I added the following to the driver commit message:

"The permissions, which enclave page is added will set the limit for maximum
permissions that can be set for mmap() and mprotect(). This will
effectively allow to build different security schemes between producers and
consumers of enclaves. Later on we can increase granularity with LSM hooks
for page addition (i.e. for producers) and mapping of the enclave (i.e. for
consumers)"

Is this sufficient? I do not want to fuzz already large patch set with
LSM patches, which anyway could not be merged before other stuff is in
the mainline. I think my description nails how we make the overall API
to be "LSM ready", doesn't it? Or at minimum gives enough information to
argue whether or not the API is "LSM ready"...

I also added CC to linux-security-module to the driver commit.

/Jarkko
