Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A124EB64DC
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Jun 2023 14:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjF0Ox1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 27 Jun 2023 10:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbjF0OxM (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 27 Jun 2023 10:53:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433462D4F
        for <linux-sgx@vger.kernel.org>; Tue, 27 Jun 2023 07:50:41 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bfee66a6398so4959912276.3
        for <linux-sgx@vger.kernel.org>; Tue, 27 Jun 2023 07:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687877439; x=1690469439;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=orfz+2Ed2EoCZeTaLTGmgEBGSK/NjHYh1Oro+oCb4dU=;
        b=On82V7dAnAdkSMx5fBAZ2IL9steLoJkypvbUc6/xuRWt5kT59sKurIwuVmIN+hsJlP
         EhsGC5vPw6j4JwT1hT6eBfbG62Vedt5w4NDxVr6djb9NZUziAITh5UmN3LQVgd/CdCJI
         XhPlyGG5pCicTmn1RI9Jc5CbdU3EtmmrikYmJe7xw4lqY31xZIHrQksICImxku/NsAFw
         QVnlT6BzCZ1pXLGZHqFtvugRlxDbSt5C3ketWio63SAkhyJkNsWEfflv8itni11xFJUY
         r61Qm+NexXVHX4wP3rQJKTrsMWdz6CNqfu5Vq0tcJtESbFFoHzulFuyNYrOSanwIL69U
         Lfng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687877439; x=1690469439;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=orfz+2Ed2EoCZeTaLTGmgEBGSK/NjHYh1Oro+oCb4dU=;
        b=FIaD7Wv6sVhM+2HFhif16Np8apRdh+HS/JdaFK2kXlmzBDGENiSEfy9/U/dKAim2Ck
         yR0WVow8QjNGu39s3IxkvIWW/+C5VoUjBRLPZ2rhKfZ2TqIsGXDmsgICpPcEP2mbPRZG
         zHptshbZOJ2RTw7X8U/RhMlAMCrOslK3oN0WhTIiB2zpOtASWjJZAjKr2VVxN4hECFt+
         V3Zigq21NVEoI3i2K+JsIGVCyQP2tShajQTvwEW3u0cFOj+2eTA2T/MHGsLR7MRe++sO
         +tU5GGTmBvO4V039rwLUxs9K4vrs3L1CQK1QMeXWontCpN9DWs5E1awubURrTefLpiAO
         FwFw==
X-Gm-Message-State: AC+VfDys3vEK8JRdX7PQ7RKQkdhXKOZgRmrylgppL7ZKoUndYEGQtUHG
        fXi+YnNecRsYuk09/zPQ8fCwHWhLqpQ=
X-Google-Smtp-Source: ACHHUZ4PoD1oTAAxn5De75rzjpbw1Pdeqzdg2I8XgutKboYPy5F62369MGH9qj06w59kYsMGUE3/iOelWb4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:814c:0:b0:c33:2a48:6262 with SMTP id
 j12-20020a25814c000000b00c332a486262mr638916ybm.13.1687877439735; Tue, 27 Jun
 2023 07:50:39 -0700 (PDT)
Date:   Tue, 27 Jun 2023 07:50:38 -0700
In-Reply-To: <7e78ec8fd22ad9f8b828fa00b9811bbfcf855b2c.camel@intel.com>
Mime-Version: 1.0
References: <e65d5e589e404f37b3f9ea15a2fd8e132d9040a1.camel@intel.com>
 <op.15kug6t9wjvjmi@hhuan26-mobl.amr.corp.intel.com> <5930de9d076d148ae572aa081c7dee8a5b696b61.camel@intel.com>
 <d0b65bbdd20a79a43d979b08972dd05bfc79b08c.camel@intel.com>
 <ZIzcrmU1RA7oEeQ7@google.com> <fc214963a01ca975d6de2991b63c93f04114c562.camel@intel.com>
 <ZJTEpH2yYtHmTRWr@google.com> <66f22efc5a920a805d6863dcc152c3c12e8fb6fb.camel@intel.com>
 <ZJoRHU1CHxIuDH29@google.com> <7e78ec8fd22ad9f8b828fa00b9811bbfcf855b2c.camel@intel.com>
Message-ID: <ZJr3PthzDgugKDcO@google.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Reinette Chatre <reinette.chatre@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 27, 2023, Kai Huang wrote:
> > > > 
> > > > You can't build an ABI on assumptions.  E.g. even if userspace *intends* to behave,
> > > > it wouldn't take much to compute the wrong offset (math is hard).
> > > 
> > > But I don't think we have an well established ABI now?  Nothing is documented.
> > 
> > Heh, just because the ABI isn't formally documented doesn't mean it doesn't exist.
> > In fact, the most problematic ABIs are the ones that aren't documented.
> > 
> > > 
> 
> Sure.  But just want to make sure, what is the current SGX driver ABI (around
> mmap()) from your perspective?

To be clear, it's not my perspective, it's simply what the kernel actually does.

> Is it "SGX driver _requires_ pgoff to be 0 for non-ELRANGE-reserve mmap()", or
> "SGX driver _ignores_ pgoff"?

Unless there are checks hiding somewhere, it's the latter.  You might be able to
get away with changing the kernel to require pgoff to be '0', i.e. if literally
all users pass in '0', but proving that all users pass '0' is extremely difficult.
And I don't see any value in requiring pgoff to be '0' for "legacy" users.

> See below ...
> 
> [...]
> 
> > > > 	if (encl->has_mismatched_offsets)  <======
> > > > 		goto unlock;
> > > 
> > > Sorry I am a little bit slow, how do you set "has_mismatched_offsests" to true?
> > 
> > During sgx_mmap().  Though there's a wrinkle I initially missed: if the enclave
> > hasn't gone through ECREATE, encl->base is garbage.  So either sgx_mmap() needs
> > to assume the !CREATED is creating a mismatched offset, or sgx_encl_create() needs
> > to iterate over and check all VMAs.
> > 
> > Since there are advantages to usuing mmap(NULL) to find ELRANGE, IMO your best
> > option is to do the below.  And then that mostly answers the question about
> > using mmap(/dev/sgx_enclave) to reserve ELRANGE, i.e. if userspace wants to use
> > fallocate(), then it effectively *must not* use mmap(/dev/sgx_enclave).
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
> > index 262f5fb18d74..63fb41da35aa 100644
> > --- a/arch/x86/kernel/cpu/sgx/driver.c
> > +++ b/arch/x86/kernel/cpu/sgx/driver.c
> > @@ -94,6 +94,11 @@ static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
> >         if (ret)
> >                 return ret;
> >  
> > +       if (!test_bit(SGX_ENCL_CREATED, &encl->flags) ||
> > +           vma->vm_pgoff != PFN_DOWN(vma->vm_start - encl->base))
> > +               encl->has_mismatched_offsests = true;
> > +
> > +
> >         vma->vm_ops = &sgx_vm_ops;
> >         vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO);
> >         vma->vm_private_data = encl;
> > 
> 
> It appears we don't need to mark "has_mismatched_offsets" as true if userspace
> uses mmap(/dev/sgx_enclave) to reserve ELRANGE?  Enclave's base isn't
> established yet, so theoretically, from enclave's perspective, we cannot say it
> has a mismatched offset.

Yeah, it's a misnomer.  Just pick a different name and that problem goes away.

	if (!test_bit(SGX_ENCL_CREATED, &encl->flags) ||
	    vma->vm_pgoff != PFN_DOWN(vma->vm_start - encl->base))
		set_bit(SGX_ENCL_DISABLE_FILE_APIS, &encl->flags);

> However we may want to return -EINVAL if userspace passes a non-zero pgoff in
> the mmap(/dev/sgx_enclave) to reserve ELRANGE.

That would potentially break userspace.  I don't personally care if you want to
try that route, but just be aware that pushing through such a change may break
someone's application.  And if that happens, be prepared to get yelled at :-)

> Anyway reserving ELRANGE isn't the big point.  The SGX driver ABI is.  Let's
> forget about reserving ELRANGE in below context, i.e., all mmap() below means
> non-ELRANGE-reserve mmap(/dev/sgx_enclave) :)
> 
> I think yes marking enclave as "has_mismatched_offsets" works if userspace wants
> to use file-based ABIs (fadvice(), etc) for enclave, but this effectively means
> Haitao needs to modify _ALL_ existing mmap()s to pass the correct pgoff in order
> to use fadvice() for EAUG.
> 
> Therefore, it seems more like we are changing ABI (or having a new ABI) to:

It's effectively new ABI.  The key point to all of this is Linus' mantra that
"we don't break userspace".   Since there can't possibly applications using fadvise()
on /dev/sgx_enclave, the kernel can define new requirements for using fadvise()
without breaking userspace.

> Userspace must pass the correct pgoff to all mmaps() in order to use file-based
> ABIs for SGX.
> 
> ( Because I think other drivers/subsystems doesn't have such limitation.  For
> instance, for a normal file, userspace can have two mmap()s mapping to the same
> offset of the same file but with different address, and fadvice() should work
> for both mappings.
>
> A VMA-based "has_mismatched_offset" seems more reasonable for SGX but as I
> mentioned previously it may not easy to do from SGX driver. )
> 
> So I am not sure whether this belongs to "breaking existing ABI"?

I think you're fixated too much on precisely defining the concept of ABI.  The
question that you really want to ask is "could change XYZ break userspace?"

> If the current ABI is we _require_ pgoff being zero, then the "encl-
> >has_mismatched_offsets" seems is breaking this ABI.
> 
> If the current ABI is we _ignore_ pgoff, then "encl->has_mismatched_offsets"
> isn't breaking existing ABI.  But in this case why do we need this at all?

Because SGX has users in the wild that don't set pgoff correctly.  Changing the
kernel to require an accurate pgoff would break those users.

> SGX driver just follows the existing file-based ABIs:
> 
> If userspace wants to use file-based ABIs for some VMA, it needs to pass the
> correct pgoff.  If not, file-based ABIs won't work for that VMA, but your
> enclave may still work if you don't use file-based ABIs.
> 
> Sorry for being noisy, but does above make sense?
