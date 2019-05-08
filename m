Return-Path: <SRS0=LoFE=TI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27617C04A6B
	for <linux-sgx@archiver.kernel.org>; Wed,  8 May 2019 13:45:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBF1E21530
	for <linux-sgx@archiver.kernel.org>; Wed,  8 May 2019 13:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfEHNpn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 8 May 2019 09:45:43 -0400
Received: from mga07.intel.com ([134.134.136.100]:29239 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbfEHNpn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 8 May 2019 09:45:43 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 06:45:42 -0700
X-ExtLoop1: 1
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.189])
  by orsmga003.jf.intel.com with ESMTP; 08 May 2019 06:45:35 -0700
Date:   Wed, 8 May 2019 16:45:34 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
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
        linux-sgx-owner@vger.kernel.org
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
Message-ID: <20190508134534.GA12114@linux.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <20190423115611.GA5604@linux.intel.com>
 <CALCETrV9SOLNw0d2tXOW1Ntmwaqso2xA2YVOvr60btR9G7Wgxg@mail.gmail.com>
 <97f057aa56be342448980a2b1e68a891@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97f057aa56be342448980a2b1e68a891@iki.fi>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Apr 24, 2019 at 03:17:47PM +0300, Jarkko Sakkinen wrote:
> For me easier path to get something done would to do ELF DSO
> first. As you said they both could be done, which means that
> Windows COFF could be upstreamed later on.
> 
> If this approach works, it'd mean that no ioctl's would be
> required except SGX_ENCLAVE_SET_ATTRIBUTE.
> 
> PS. This quote from LWN got a bit into my feelings:
> 
> "After 20 revisions of the patch set over three years, the
> authors of this work (which was posted by Jarkko Sakkinen)
> might well be forgiven for thinking that it must be about
> ready for merging."
> 
> I seriously do not make any pre-conclusions ever for any patch
> that I post when it should be merged, no matter how big or
> small :-) For me this is just work...

Just throwing this out of my head so that all options are considered but
wouldn't one alternative to get things right be to replace ioctl with a
syscall? Not endorsing this option in particular but I think you could
get security right by doing this.

Even with dlopen() you need ioctl's for setting attributes (e.g.
provisioning) and EINIT. A syscall would be in some ways more sound.

/Jarkko
