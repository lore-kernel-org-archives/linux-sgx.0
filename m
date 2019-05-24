Return-Path: <SRS0=Nb5J=TY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A95C8C282DE
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 01:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48D91217F9
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 01:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558660695;
	bh=7lZcMPoWnmeu0Lf6tScsQ7kQKOEs9HqN2DCaPjTfUzo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=pXnoWqWfDIE3qDpqrgYfeawMbCZPdJ4zAqDZuwwvcKdQUhjaD5qAsx0Jpc5EqqUgY
	 joTuwzFHqEmYZq+x9PKGvCWKwinqH15REvWJFV6UqwhHv7rxwkE+V0U3O1DkRvNq6L
	 Z+5S+TZb2CLfla6gP9uYRnhqr0MNHNqRNGBxrBKA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389174AbfEXBSL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 23 May 2019 21:18:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389170AbfEXBSL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 23 May 2019 21:18:11 -0400
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59ABC218A4
        for <linux-sgx@vger.kernel.org>; Fri, 24 May 2019 01:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558660688;
        bh=7lZcMPoWnmeu0Lf6tScsQ7kQKOEs9HqN2DCaPjTfUzo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=L17Jfa/Us2ZXApwta7cAoOC9c3NGw2tm1QB1VurrQU0TaWCdhiMet8mHL20XvrAqV
         TH20q/gdWLNJKa3bM34yERSCAPx4cIp6M17ITISjzJRIM+um7KyEETShxLr84/uD5V
         7pxeT3K+W7thx1oE8oyiPHYiMXItdqJ/8+384sO0=
Received: by mail-wm1-f44.google.com with SMTP id f204so7625480wme.0
        for <linux-sgx@vger.kernel.org>; Thu, 23 May 2019 18:18:08 -0700 (PDT)
X-Gm-Message-State: APjAAAXWUFUFJl1N+9PTsvoNpqKZsdqcOMnDa4PY46luAgSu1TMQCs/j
        V+pptD0RPQg4rirAHeDxI+pa0Cd38GTQxckoyDetxg==
X-Google-Smtp-Source: APXvYqzXf5nwlCxNugY+uLWyzOZ9Xhqu+wCaxbeB64RQCTiklz7s0koNHkWVqoGAsX1sGLapxPd2pMZLHx17rxuWBSA=
X-Received: by 2002:a1c:e906:: with SMTP id q6mr14707368wmc.47.1558660686807;
 Thu, 23 May 2019 18:18:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190521155140.GE22089@linux.intel.com> <20190522132022.GC31176@linux.intel.com>
 <20190522132227.GD31176@linux.intel.com> <0e183cce-c4b4-0e10-dbb6-bd81bea58b66@tycho.nsa.gov>
 <20190522153836.GA24833@linux.intel.com> <CALCETrUS8xyF1JJmQs18BGTDhPRXf+s81BkMZCZwmY73r7M+zg@mail.gmail.com>
 <20190523023517.GA31950@linux.intel.com> <20190523102628.GC10955@linux.intel.com>
 <20190523141752.GA12078@linux.intel.com> <CALCETrUzx3LPAKCLFf75P-XshAkRcr+JLET3LA_kHDs9MA11FA@mail.gmail.com>
 <20190523234044.GC12078@linux.intel.com>
In-Reply-To: <20190523234044.GC12078@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 23 May 2019 18:17:54 -0700
X-Gmail-Original-Message-ID: <CALCETrV4DVEfW6EJ6DnQGGYDJAiA5M1QcuYJTiroumOM+D6Jjg@mail.gmail.com>
Message-ID: <CALCETrV4DVEfW6EJ6DnQGGYDJAiA5M1QcuYJTiroumOM+D6Jjg@mail.gmail.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
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

On Thu, May 23, 2019 at 4:40 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, May 23, 2019 at 08:38:17AM -0700, Andy Lutomirski wrote:
> > On Thu, May 23, 2019 at 7:17 AM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > On Thu, May 23, 2019 at 01:26:28PM +0300, Jarkko Sakkinen wrote:
> > > > On Wed, May 22, 2019 at 07:35:17PM -0700, Sean Christopherson wrote:
> > > > > But actually, there's no need to disallow mmap() after ECREATE since the
> > > > > LSM checks also apply to mmap(), e.g. FILE__EXECUTE would be needed to
> > > > > mmap() any enclave pages PROT_EXEC.  I guess my past self thought mmap()
> > > > > bypassed LSM checks?  The real problem is that mmap()'ng an existing
> > > > > enclave would require FILE__WRITE and FILE__EXECUTE, which puts us back
> > > > > at square one.
> > > >
> > > > I'm lost with the constraints we want to set.
> > >
> > > As is today, SELinux policies would require enclave loaders to have
> > > FILE__WRITE and FILE__EXECUTE permissions on /dev/sgx/enclave.  Presumably
> > > other LSMs have similar requirements.  Requiring all processes to have
> > > FILE__{WRITE,EXECUTE} permissions means the permissions don't add much
> > > value, e.g. they can't be used to distinguish between an enclave that is
> > > being loaded from an unmodified file and an enclave that is being
> > > generated on the fly, e.g. Graphene.
> > >
> > > Looking back at Andy's mail, he was talking about requiring FILE__EXECUTE
> > > to run an enclave, so perhaps it's only FILE__WRITE that we're trying to
> > > special case.
> > >
> >
> > I thought about this some more, and I have a new proposal that helps
> > address the ELRANGE alignment issue and the permission issue at the
> > cost of some extra verbosity.  Maybe you all can poke holes in it :)
> > The basic idea is to make everything more explicit from a user's
> > perspective.  Here's how it works:
> >
> > Opening /dev/sgx/enclave gives an enclave_fd that, by design, doesn't
> > give EXECUTE or WRITE.  mmap() on the enclave_fd only works if you
> > pass PROT_NONE and gives the correct alignment.  The resulting VMA
> > cannot be mprotected or mremapped.  It can't be mmapped at all until
>
> I assume you're thinking of clearing all VM_MAY* flags in sgx_mmap()?
>
> > after ECREATE because the alignment isn't known before that.
>
> I don't follow.  The alignment is known because userspace knows the size
> of its enclave.  The initial unknown is the address, but that becomes
> known once the initial mmap() completes.

[...]

I think I made the mistake of getting too carried away with
implementation details rather than just getting to the point.  And I
misremembered the ECREATE flow -- oops.  Let me try again.  First,
here are some problems with some earlier proposals (mine, yours
Cedric's):

 - Having the EADD operation always work but have different effects
depending on the source memory permissions is, at the very least,
confusing.

 - If we want to encourage user programs to be well-behaved, we want
to make it easy to map the RX parts of an enclave RX, the RW parts RW,
the RO parts R, etc.  But this interacts poorly with the sgx_mmap()
alignment magic, as you've pointed out.

 - We don't want to couple LSMs with SGX too tightly.

So here's how a nice interface might work:

int enclave_fd = open("/dev/sgx/enclave", O_RDWR);

/* enclave_fd points to a totally blank enclave. Before ECREATE, we
need to decide on an address. */

void *addr = mmap(NULL, size, PROT_NONE, MAP_SHARED, enclave_fd, 0);

/* we have an address! */

ioctl(enclave_fd, ECREATE, ...);

/* now add some data to the enclave.  We want the RWX addition to fail
immediately unless we have the relevant LSM pemission.   Similarly, we
want the RX addition to fail immediately unless the source VMA is
appropriate. */

ioctl(enclave_fd, EADD, rx_source_1, MAXPERM=RX, ...);  [the ...
includes SECINFO, which the kernel doesn't really care about]
ioctl(enclave_fd, EADD, ro_source_1, MAXPERM=RX ...);
ioctl(enclave_fd, EADD, rw_source_1, MAXPERM=RW ...);
ioctl(enclave_fd, EADD, rwx_source_1, MAXPERM=RWX ...);

ioctl(enclave_fd, EINIT, ...);  /* presumably pass sigstruct_fd here, too. */

/* at this point, all is well except that the enclave is mapped
PROT_NONE. There are a couple ways I can imagine to fix this. */

We could use mmap:

mmap(baseaddr+offset, len, PROT_READ, MAP_SHARED | MAP_FIXED,
enclave_fd, 0);  /* only succeeds if MAXPERM & R == R */

But this has some annoying implications with regard to
sgx_get_unmapped_area().  We could use an ioctl:

ioctl(enclave_fd, SGX_IOC_MPROTECT, offset, len, PROT_READ);

which has the potentially nice property that we can completely bypass
the LSM hooks, because the LSM has *already* vetted everything when
the EADD calls were allowed.  Or we could maybe even just use
mprotect() itself:

mprotect(baseaddr + offset, len, PROT_READ);

Or, for the really evil option, we could use a bit of magic in .fault
and do nothing here.  Instead we'd make the initial mapping
PROT_READ|PROT_WRITE|PROT_EXEC and have .fault actually instantiate
the PTEs with the intersection of the VMA permissions and MAXPERM.  I
don't think I like this alternative, since it feels more magical than
needed and it will be harder to debug.  I like the fact that
/proc/self/maps shows the actual permissions in all the other
variants.


All of the rest of the crud in my earlier email was just
implementation details.  The point I was trying to make was that I
think it's possible to implement this without making too much of a
mess internally.  I think I favor the mprotect() approach since it
makes the behavior fairly obvious.

I don't think any of this needs to change for SGX2.  We'd have an
ioctl() that does EAUG and specifies MAXPERM.  Trying to mprotect() a
page that hasn't been added yet with any permission other than
PROT_NONE would fail.  I suppose we might end up needing a way to let
the EAUG operation *change* MAXPERM, and this operation would have to
do some more LSM checks and walk all the existing mappings to make
sure they're consistent with the new MAXPERM.

As an aside, I wonder if Linus et all would be okay with a new
MAP_FULLY_ALIGNED mmap() flag that allocated memory aligned to the
requested size.  Then we could get rid of yet another bit of magic.

--Andy
