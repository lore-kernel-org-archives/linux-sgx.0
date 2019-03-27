Return-Path: <SRS0=L3CU=R6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF0BC10F0A
	for <linux-sgx@archiver.kernel.org>; Wed, 27 Mar 2019 00:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5856B2087C
	for <linux-sgx@archiver.kernel.org>; Wed, 27 Mar 2019 00:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731770AbfC0AOG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 26 Mar 2019 20:14:06 -0400
Received: from mga18.intel.com ([134.134.136.126]:54021 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbfC0AOG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 26 Mar 2019 20:14:06 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Mar 2019 17:14:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,274,1549958400"; 
   d="scan'208";a="128938926"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga008.jf.intel.com with ESMTP; 26 Mar 2019 17:14:04 -0700
Date:   Tue, 26 Mar 2019 17:14:04 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, nhorman@redhat.com,
        npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v19 17/27] x86/sgx: Add provisioning
Message-ID: <20190327001404.GM3757@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-18-jarkko.sakkinen@linux.intel.com>
 <CALCETrXQ0x2TD5GnaHhmF6SExk0C8+L0AwfnH-Krqwttfvwz2A@mail.gmail.com>
 <20190322112938.GJ3122@linux.intel.com>
 <20190322114325.GA10165@linux.intel.com>
 <CALCETrW=Fr8EdVq+5FLbmdL__i82FC0ONHd=hBXjxpLcsv9M0Q@mail.gmail.com>
 <20190325145503.GB29989@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190325145503.GB29989@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 25, 2019 at 04:55:03PM +0200, Jarkko Sakkinen wrote:
> On Fri, Mar 22, 2019 at 11:20:30AM -0700, Andy Lutomirski wrote:
> > On Fri, Mar 22, 2019 at 4:43 AM Jarkko Sakkinen
> > <jarkko.sakkinen@linux.intel.com> wrote:
> > >
> > > On Fri, Mar 22, 2019 at 01:29:38PM +0200, Jarkko Sakkinen wrote:
> > > > On Thu, Mar 21, 2019 at 09:50:41AM -0700, Andy Lutomirski wrote:
> > > > > On Sun, Mar 17, 2019 at 2:18 PM Jarkko Sakkinen
> > > > > <jarkko.sakkinen@linux.intel.com> wrote:
> > > > > >
> > > > > > In order to provide a mechanism for devilering provisoning rights:
> > > > > >
> > > > > > 1. Add a new file to the securityfs file called sgx/provision that works
> > > > > >    as a token for allowing an enclave to have the provisioning privileges.
> > > > > > 2. Add a new ioctl called SGX_IOC_ENCLAVE_SET_ATTRIBUTE that accepts the
> > > > > >    following data structure:
> > > > > >
> > > > > >    struct sgx_enclave_set_attribute {
> > > > > >            __u64 addr;
> > > > > >            __u64 token_fd;
> > > > > >    };
> > > > >
> > > > > Here's a potential issue:
> > > > >
> > > > > For container use, is it reasonable for a container manager to
> > > > > bind-mount a file into securityfs?  Or would something in /dev make
> > > > > this easier?
> > > >
> > > > I guess that is a valid point given that the securityfs contains the LSM
> > > > (e.g. SELinux or AppArmor) policy. So yeah, I think your are right what
> > > > you say.
> > > >
> > > > I propose that we create /dev/sgx/enclave to act as the enclave manager
> > > > and /dev/sgx/provision for provisioning. Is this sustainable for you?
> > >
> > > Hmm.. on 2nd thought the LSM policy or even DAC policy  would restrict
> > > that the container manager can only access specific files inside
> > > securityfs. With this conclusion I still think it is probably the best
> > > place for seurity policy like things even for SGX. It is meant for that
> > > anyway.
> > >
> > 
> > LSM or DAC policy can certainly *restrict* it, but I suspect that most
> > container runtimes don't mount securityfs at all.  OTOH, the runtime
> > definitely needs to have a way to pass /dev/sgx/enclave (or whatever
> > it's called) through, so using another device node will definitely
> > work.
> 
> OK, I can cope with this argument. I go with the device names above for
> v20.

Regardless of where the file ends up living, I think it should be owned
by the "core" SGX subsystem and not the driver.  At some point in the
past Andy requested that KVM intercept EINIT as needed to prevent
unauthorized access to the PROVISION_KEY (by running a KVM guest),
I.e. userspace may want to access /dev/sgx/provision or whatever even
if the driver is not loaded.  I don't see any reason to defer that change
to the KVM series.

If the ACPI-based autoprobing is removed, then sgx_init() can remove the
file if probing the driver fails, i.e. the kernel won't end up with a
file that userspace can't use for anything.
