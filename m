Return-Path: <SRS0=QGFU=VE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 439B1C48BE1
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Jul 2019 18:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AEC420828
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Jul 2019 18:02:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbfGGSB7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 7 Jul 2019 14:01:59 -0400
Received: from mga17.intel.com ([192.55.52.151]:45703 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbfGGSB5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 7 Jul 2019 14:01:57 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jul 2019 11:01:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,463,1557212400"; 
   d="scan'208";a="173078241"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Jul 2019 11:01:56 -0700
Date:   Sun, 7 Jul 2019 11:01:56 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [RFC PATCH v4 07/12] LSM: x86/sgx: Introduce ->enclave_map()
 hook for Intel SGX
Message-ID: <20190707180156.GA19593@linux.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-8-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551847B@ORSMSX116.amr.corp.intel.com>
 <8235709b-9034-4751-30ce-720e41e31525@tycho.nsa.gov>
 <960B34DE67B9E140824F1DCDEC400C0F6551B85C@ORSMSX116.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F6551B85C@ORSMSX116.amr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 27, 2019 at 01:29:39PM -0700, Xing, Cedric wrote:
> > From: linux-sgx-owner@vger.kernel.org [mailto:linux-sgx-
> > owner@vger.kernel.org] On Behalf Of Stephen Smalley
> > Sent: Tuesday, June 25, 2019 1:48 PM
> > 
> > On 6/21/19 12:54 PM, Xing, Cedric wrote:
> > >> From: Christopherson, Sean J
> > >> Sent: Wednesday, June 19, 2019 3:24 PM
> > >>
> > >> diff --git a/security/security.c b/security/security.c index
> > >> 613a5c00e602..03951e08bdfc 100644
> > >> --- a/security/security.c
> > >> +++ b/security/security.c
> > >> @@ -2359,3 +2359,10 @@ void security_bpf_prog_free(struct
> > bpf_prog_aux *aux)
> > >>   	call_void_hook(bpf_prog_free_security, aux);
> > >>   }
> > >>   #endif /* CONFIG_BPF_SYSCALL */
> > >> +
> > >> +#ifdef CONFIG_INTEL_SGX
> > >> +int security_enclave_map(unsigned long prot) {
> > >> +	return call_int_hook(enclave_map, 0, prot); } #endif /*
> > >> +CONFIG_INTEL_SGX */
> > >
> > > Why is this new security_enclave_map() necessary while
> > security_mmap_file() will also be invoked?
> > 
> > security_mmap_file() doesn't know about enclaves.  It will just end up
> > checking FILE__READ, FILE__WRITE, and FILE__EXECUTE to /dev/sgx/enclave.
> > This was noted in the patch description.
> 
> Surely I understand all those. As I mentioned in my other email,
> enclave_load() could indicate to LSM that a file is an enclave. Of course
> mmap() could be invoked before any pages are loaded so LSM wouldn't know at
> the first mmap(), but that doesn't matter as an empty enclave wouldn't post
> any threats anyway.

security_mmap_file() is invoked before the final address is known, and
MAP_FIXED isn't technically required.
