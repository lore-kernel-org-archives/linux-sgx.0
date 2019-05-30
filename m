Return-Path: <SRS0=2c9w=T6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0472EC46460
	for <linux-sgx@archiver.kernel.org>; Thu, 30 May 2019 19:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D19B0260B7
	for <linux-sgx@archiver.kernel.org>; Thu, 30 May 2019 19:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559244061;
	bh=Odh5mJR7Qgs8tP+o4xgz7GTPiNe9Lb/ibVAyREXQGqQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=yqRSQ9v159eIHTgYRaKgxRHHyaqFzuA6hrw7tD10cTWw2X6arxs8JrkndTJhUEm7P
	 hTqIaitk52aec9mcX/czmv0X7DO1ttca7p+ct0N7B7GTjGCEAAkmvK1uZqlf8qLqdL
	 nua8kfyissmHFBlV0OyEkUKPIu/w7VwIvwHnlnCk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfE3TVB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 30 May 2019 15:21:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbfE3TVA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 30 May 2019 15:21:00 -0400
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7D04260CA
        for <linux-sgx@vger.kernel.org>; Thu, 30 May 2019 19:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559244059;
        bh=Odh5mJR7Qgs8tP+o4xgz7GTPiNe9Lb/ibVAyREXQGqQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=k1VTA2qU/RD8Hs7QLYGbUetg3lfpgX8214GkgLedrTURhqCoR0r7gjkRxDYxxEonb
         gTc8bbpVFJ7fgrtdK662jLwj7iXrBIGIuLY91PlWLaVSKxh9ozJOy21jpK7qOpAcQg
         6IAmBphU87+WYP27EHkPfBt4ShDmO/Guk3AeZ7dk=
Received: by mail-wr1-f50.google.com with SMTP id p11so79127wre.7
        for <linux-sgx@vger.kernel.org>; Thu, 30 May 2019 12:20:58 -0700 (PDT)
X-Gm-Message-State: APjAAAVmHn0dRx1CoVZEWYapTX0gglwSA4zMQ59Hd6dnsK5NsEsVW9Lv
        bqWq+rB0usPAt8lD/Cql2sJKcfwjBtDUaZYtTBYu1g==
X-Google-Smtp-Source: APXvYqy73ZMq0qQmmQ/+vAioP4b3Sl7JgF5MBuyujqDcT8diOwfoebNcCtYnbTp7wfhGb0A0cPCz00xyeb2Lc9Xg3WE=
X-Received: by 2002:a5d:6207:: with SMTP id y7mr3442998wru.265.1559244057293;
 Thu, 30 May 2019 12:20:57 -0700 (PDT)
MIME-Version: 1.0
References: <960B34DE67B9E140824F1DCDEC400C0F654E965F@ORSMSX116.amr.corp.intel.com>
 <CALCETrXXVMutX8eZk6nnkOAeS+Tj0sQd0FkW+wk6Rx8hQxCe6w@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E9824@ORSMSX116.amr.corp.intel.com>
 <20190528202407.GB13158@linux.intel.com> <285f279f-b500-27f0-ab42-fb1dbcc5ab18@tycho.nsa.gov>
 <960B34DE67B9E140824F1DCDEC400C0F654EB487@ORSMSX116.amr.corp.intel.com>
 <678a37af-797d-7bd5-a406-32548a270e3d@tycho.nsa.gov> <CALCETrWXB9fNNDH7gZxPTx05F78Og6K=ZtAr2aA++BDwY09Wbg@mail.gmail.com>
 <c1135352-0b5e-4694-b1a9-105876095877@tycho.nsa.gov> <CALCETrWsEXzUC33eJpGCpdMCBO4aYVviZLRD-CLMNaG5Jv-TCA@mail.gmail.com>
 <20190530180110.GB23930@linux.intel.com>
In-Reply-To: <20190530180110.GB23930@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 30 May 2019 12:20:45 -0700
X-Gmail-Original-Message-ID: <CALCETrX2PgUc_jetXHqp85aaS0a0jHB8E7=T1rsW+5vyRgwnUA@mail.gmail.com>
Message-ID: <CALCETrX2PgUc_jetXHqp85aaS0a0jHB8E7=T1rsW+5vyRgwnUA@mail.gmail.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        William Roberts <bill.c.roberts@gmail.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 30, 2019 at 11:01 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, May 30, 2019 at 09:14:10AM -0700, Andy Lutomirski wrote:
> > On Thu, May 30, 2019 at 8:04 AM Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > >
> > > On 5/30/19 10:31 AM, Andy Lutomirski wrote:
> > > > Hi all-
> > > >
> > > > After an offline discussion with Sean yesterday, here are some updates
> > > > to the user API parts of my proposal.
> > > >
> > > > Unfortunately, Sean convinced me that MAXPERM doesn't work the way I
> > > > described it because, for SGX2, the enclave loader won't know at load
> > > > time whether a given EAUG-ed page will ever be executed.  So here's an
> > > > update.
> > > >
> > > > First, here are the requrements as I see them, where EXECUTE, EXECMOD,
> > > > and EXECMEM could be substituted with other rules at the LSM's
> > > > discretion:
> > > >
> > > >   - You can create a WX or RWX mapping if and only if you have EXECMEM.
> > > >
> > > >   - To create an X mapping of an enclave page that has ever been W, you
> > > > need EXECMOD.
> > >
> > > EXECMOD to what file? The enclave file from which the page's content
> > > originated, the sigstruct file, or /dev/sgx/enclave?
> >
> > I leave that decision to you :)  The user should need permission to do
> > an execmod thing on an enclave, however that wants to be encoded.
>
> But that decision dictates how the SGX API handles sigstruct.  If LSMs
> want to associate EXECMOD with sigstruct, then SGX needs to take sigstruct
> early and hold a reference to the file for the lifetime of the enclave.
> And if we're going to do that, the whole approach of inheriting
> permissions from source VMAs becomes unnecessary complexity.
>
> > >
> > > >   - To create an X mapping of an enclave page that came from EADD, you
> > > > need EXECUTE on the source file.  Optionally, we could also permit
> > > > this if you have EXECMOD.
> > >
> > > What is the "source file" i.e. the target of the check?  Enclave file,
> > > sigstruct file, or /dev/sgx/enclave?
> >
> > Enclave file -- that is, the file backing the vma from which the data is loaded.
>
> It wasn't explicitly called out in Andy's proposal(s), but the idea is
> that the SGX driver would effectively inherit permissions from the source
> VMA (EADD needs a source for the initial value of the encave page).

I actually meant for it to *not* work like this.  I don't want the
source VMA to have to be VM_EXEC.  I think the LSM should just check
permissions on ->vm_file.
