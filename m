Return-Path: <SRS0=8iz8=RZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6397CC10F03
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Mar 2019 13:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EDF62075E
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Mar 2019 13:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731502AbfCVLnh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 Mar 2019 07:43:37 -0400
Received: from mga05.intel.com ([192.55.52.43]:2887 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731176AbfCVLnh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 22 Mar 2019 07:43:37 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Mar 2019 04:43:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,256,1549958400"; 
   d="scan'208";a="216551682"
Received: from vanderss-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.199])
  by orsmga001.jf.intel.com with ESMTP; 22 Mar 2019 04:43:26 -0700
Date:   Fri, 22 Mar 2019 13:43:25 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
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
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v19 17/27] x86/sgx: Add provisioning
Message-ID: <20190322114325.GA10165@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-18-jarkko.sakkinen@linux.intel.com>
 <CALCETrXQ0x2TD5GnaHhmF6SExk0C8+L0AwfnH-Krqwttfvwz2A@mail.gmail.com>
 <20190322112938.GJ3122@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190322112938.GJ3122@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 22, 2019 at 01:29:38PM +0200, Jarkko Sakkinen wrote:
> On Thu, Mar 21, 2019 at 09:50:41AM -0700, Andy Lutomirski wrote:
> > On Sun, Mar 17, 2019 at 2:18 PM Jarkko Sakkinen
> > <jarkko.sakkinen@linux.intel.com> wrote:
> > >
> > > In order to provide a mechanism for devilering provisoning rights:
> > >
> > > 1. Add a new file to the securityfs file called sgx/provision that works
> > >    as a token for allowing an enclave to have the provisioning privileges.
> > > 2. Add a new ioctl called SGX_IOC_ENCLAVE_SET_ATTRIBUTE that accepts the
> > >    following data structure:
> > >
> > >    struct sgx_enclave_set_attribute {
> > >            __u64 addr;
> > >            __u64 token_fd;
> > >    };
> > 
> > Here's a potential issue:
> > 
> > For container use, is it reasonable for a container manager to
> > bind-mount a file into securityfs?  Or would something in /dev make
> > this easier?
> 
> I guess that is a valid point given that the securityfs contains the LSM
> (e.g. SELinux or AppArmor) policy. So yeah, I think your are right what
> you say.
> 
> I propose that we create /dev/sgx/enclave to act as the enclave manager
> and /dev/sgx/provision for provisioning. Is this sustainable for you?

Hmm.. on 2nd thought the LSM policy or even DAC policy  would restrict
that the container manager can only access specific files inside
securityfs. With this conclusion I still think it is probably the best
place for seurity policy like things even for SGX. It is meant for that
anyway.

/Jarkko
