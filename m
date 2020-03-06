Return-Path: <SRS0=xE7g=4X=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC9DC10DCE
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Mar 2020 18:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A30E2067C
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Mar 2020 18:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgCFSe4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 6 Mar 2020 13:34:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:23402 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbgCFSe4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 6 Mar 2020 13:34:56 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Mar 2020 10:34:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,523,1574150400"; 
   d="scan'208";a="442031866"
Received: from wbakowsk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.27.142])
  by fmsmga006.fm.intel.com with ESMTP; 06 Mar 2020 10:34:53 -0800
Date:   Fri, 6 Mar 2020 20:34:52 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "Dr. Greg" <greg@enjellic.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>
Subject: Re: x86/sgx: v23-rc2
Message-ID: <20200306183452.GB7472@linux.intel.com>
References: <20200215072406.GA9958@linux.intel.com>
 <ed49f988-e4e5-b2b9-0108-f489e9b5f449@fortanix.com>
 <20200217185512.GA7677@linux.intel.com>
 <20200218104243.GA13967@wind.enjellic.com>
 <20200218155247.GA18374@linux.intel.com>
 <20200219162640.GA29921@wind.enjellic.com>
 <20200220195537.GA23349@linux.intel.com>
 <20200221011913.GA15165@wind.enjellic.com>
 <20200221130009.GB3112@linux.intel.com>
 <20200305195157.GO11500@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305195157.GO11500@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 05, 2020 at 11:51:57AM -0800, Sean Christopherson wrote:
> On Fri, Feb 21, 2020 at 03:00:31PM +0200, Jarkko Sakkinen wrote:
> > On Thu, Feb 20, 2020 at 07:19:13PM -0600, Dr. Greg wrote:
> > > > > This would seem to imply that the driver is rather firmly architected
> > > > > on the notion of one open() per enclave, a concept that Jethro seems
> > > > > to have issues with.
> > > 
> > > > I don't understand what concept you are talking about.
> > > 
> > > If memory serves me correctly, Jethro envisioned a model where a
> > > single open of the SGX driver node would return a file descriptor that
> > > could then be used to create/load/initialize multiple enclaves.  Your
> > > clarifications indicate that a separate open will be needed for each
> > > and every enclave instance that will be orchestrated.
> > > 
> > > Jethro, if I'm mistating your position on this, please jump in and
> > > clarify.
> > 
> > Ah.
> > 
> > You are speaking about having a factory to create enclaves and a
> > management interface. I.e. you'd have ioctl to create enclave that gives
> > you a file descriptor to access its management interface.
> > 
> > Out of top of my head I cannot recall why this was not favored in the
> > end but generally speaking added complexity should be justified by some
> > considerably strong measures.
> 
> The primary issue is that having an ioctl() to create enclaves means the
> enclave fd would be an anon inode.  From a security (well, SELinux)
> perspective, anon inodes are problematic for two reasons:
> 
>   - Anon inodes are exempt from SELinux ioctl() whitelisting.  This
>     probably isn't a huge deal?
> 
>   - Mapping an anon inode with PROT_EXEC requires SELinux's EXECMEM, i.e.
>     all enclave runtimes would require EXECMEM, which is a big step
>     backwards in terms of security and drew the ire of Linus[1].
> 
> That being said, there is a proposed patch set to add support for "secure"
> anon inodes[2], which I believe would eliminate all of the above problems.
> Of course we'd be stuck with the current anon inode behavior until that
> patch set lands (I'm feeling optomistic today ;-) ).
> 
> [1] https://lkml.kernel.org/r/CAHk-=wjmT=uC1=18ZYV1CMfP_FBUEjh9_rabH0g+a0z-L0cgHg@mail.gmail.com
> [2] https://lkml.kernel.org/r/20200214032635.75434-1-dancol@google.com

Still does not address what I said in my response: what are the
strong enough measures to use anon inode in the first place even
if there is a "secure" version.

/Jarkko
