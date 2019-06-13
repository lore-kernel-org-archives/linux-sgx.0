Return-Path: <SRS0=rpH8=UM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07172C31E45
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 23:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D58E72133D
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 23:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfFMXR4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jun 2019 19:17:56 -0400
Received: from mga12.intel.com ([192.55.52.136]:13074 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726519AbfFMXR4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Jun 2019 19:17:56 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 16:17:55 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 13 Jun 2019 16:17:55 -0700
Date:   Thu, 13 Jun 2019 16:17:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "pmccallum@redhat.com" <pmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Subject: Re: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in
 SELinux
Message-ID: <20190613231755.GD18385@linux.intel.com>
References: <cover.1560131039.git.cedric.xing@intel.com>
 <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com>
 <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov>
 <20190611220243.GB3416@linux.intel.com>
 <8d99d8fb-a921-286a-8cf0-cd522e09b37c@tycho.nsa.gov>
 <960B34DE67B9E140824F1DCDEC400C0F65503EDD@ORSMSX116.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F65503EDD@ORSMSX116.amr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 13, 2019 at 04:03:24PM -0700, Xing, Cedric wrote:
> > From: Stephen Smalley [mailto:sds@tycho.nsa.gov]
> > Sent: Thursday, June 13, 2019 10:02 AM
> > 
> > > My RFC series[1] implements #1.  My understanding is that Andy
> > > (Lutomirski) prefers #2.  Cedric's RFC series implements #3.
> > >
> > > Perhaps the easiest way to make forward progress is to rule out the
> > > options we absolutely *don't* want by focusing on the potentially
> > > blocking issue with each option:
> > >
> > >    #1 - SGX UAPI funkiness
> > >
> > >    #2 - Auditing complexity, potential enclave lock contention
> > >
> > >    #3 - Pushing SGX details into LSMs and complexity of kernel
> > > implementation
> > >
> > >
> > > [1]
> > > https://lkml.kernel.org/r/20190606021145.12604-1-sean.j.christopherson
> > > @intel.com
> > 
> > Given the complexity tradeoff, what is the clear motivating example for
> > why #1 isn't the obvious choice? That the enclave loader has no way of
> > knowing a priori whether the enclave will require W->X or WX?  But
> > aren't we better off requiring enclaves to be explicitly marked as
> > needing such so that we can make a more informed decision about whether
> > to load them in the first place?
> 
> Are you asking this question at a) page granularity, b) file granularity or
> c) enclave (potentially comprised of multiple executable files) granularity?
> 
> #b is what we have on regular executable files and shared objects (i.e.
> FILE__EXECMOD). We all know how to do that.
> 
> #c is kind of new but could be done via some proxy file (e.g. sigstruct file)
> hence reduced to #b.
> 
> #a is problematic. It'd require compilers/linkers to generate such
> information, and proper executable image file format to carry that
> information, to be eventually picked up the loader. SELinux doesn't have
> PAGE__EXECMOD I guess is because it is generally considered impractical.
> 
> Option #1 however requires #a because the driver doesn't track which page was
> loaded from which file, otherwise it can no longer be qualified "simple". Or
> we could just implement #c, which will make all options simpler. But I guess
> #b is still preferred, to be aligned with what SELinux is enforcing today on
> regular memory pages.o

Option #1 doesn't require (a).  The checks will happen for every page,
but in the RFCs I sent, the policies are still attached to files and
processes, i.e. (b).
