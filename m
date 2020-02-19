Return-Path: <SRS0=z1MW=4H=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1288C34047
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Feb 2020 16:27:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1AC92465D
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Feb 2020 16:27:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgBSQ1A (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Feb 2020 11:27:00 -0500
Received: from wind.enjellic.com ([76.10.64.91]:57502 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbgBSQ1A (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Feb 2020 11:27:00 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 01JGQgj9030169;
        Wed, 19 Feb 2020 10:26:42 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 01JGQeiM030168;
        Wed, 19 Feb 2020 10:26:40 -0600
Date:   Wed, 19 Feb 2020 10:26:40 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>
Subject: Re: x86/sgx: v23-rc2
Message-ID: <20200219162640.GA29921@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <a657081e-cdaf-7c9d-2695-23c9c07bcfbf@fortanix.com> <20191011181550.GB30935@linux.intel.com> <8dc2ab24-baf1-5e57-3906-35e7286f7ffe@fortanix.com> <20191017175735.GD20903@linux.intel.com> <eaf66973-9c9b-b06c-4b96-134e41c18d80@fortanix.com> <20200215072406.GA9958@linux.intel.com> <ed49f988-e4e5-b2b9-0108-f489e9b5f449@fortanix.com> <20200217185512.GA7677@linux.intel.com> <20200218104243.GA13967@wind.enjellic.com> <20200218155247.GA18374@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218155247.GA18374@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Wed, 19 Feb 2020 10:26:42 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Feb 18, 2020 at 05:52:47PM +0200, Jarkko Sakkinen wrote:

Good morning, I hope the day is going well for everyone.

> On Tue, Feb 18, 2020 at 04:42:43AM -0600, Dr. Greg Wettstein wrote:
> > I believe an accurate summary of Dr. Beekman's concerns are as
> > follows:
> > 
> > 1.) He envisions a need for an enclave orchestrator that uses root
> > privileges to open the SGX driver device and then drop privileges,
> > presumably in a permanent fashion.  The orchestrator would then use
> > the filehandle to load and initialize multiple enclaves on request.
> > 
> > 2.) The enclave orchestrator may be run in an environment that has
> > SECCOMP limitations on the ability to conduct filesystem operations.

> Also UDS sockets with SCM_RIGHTS should work.

The first clarification, I'm assuming you mean passing SCM_RIGHTS over
AF_UNIX/UNIX-domain sockets, not UDP sockets?

Secondly, it was my understanding that the reason major renovations to
the driver were initiated, almost a year ago now, was to create a
situation where there was a filehandle per enclave in order for the
LSM to get a 'look' at the executable TEXT that was being deployed to
the enclave.

It appears that the sgx_open() function, that is installed as the
->open method for the /dev/sgx/enclave device node, allocates the
master enclave definition structure, that is installed, and
subsequently released, as private data for the file instance object.
This master enclave structure has the reference to the virtual memory
definition for the enclave that is opened.

This would seem to imply that the driver is rather firmly architected
on the notion of one open() per enclave, a concept that Jethro seems
to have issues with.

> /Jarkko

Have a good day.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker
IDfusion, LLC               SGX secured infrastructure and
4206 N. 19th Ave.           autonomously self-defensive platforms.
Fargo, ND  58102
PH: 701-281-1686            EMAIL: greg@idfusion.net
------------------------------------------------------------------------------
"Artifical Intelligence stands no chance against Natural Stupidity."
                                -- John Henders
