Return-Path: <SRS0=zBz/=O2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A0BC43387
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 20:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8410F21841
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 20:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545077432;
	bh=ryMIVu4Zmu6P2F/2xwOzzWnMPWMEZsy0oZCxTdFnGgo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=YAYh9d2NTCwMpoRtbT+IzSOUatxntjD41PpQBDg1Nqi4ezVAeBIhiWyksOi4PZ8mh
	 dnOyO43MqcXCO7UyzizoqVBYS5AZT4y3iV28hZeqXfDGxgMAFZdpeeNRnf0dsNtTgP
	 R1nR+/WMsxlk+4E2YQTM6onHe7LJ9uqVSfRDgOdU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbeLQUKc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Dec 2018 15:10:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:38654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727038AbeLQUKc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Dec 2018 15:10:32 -0500
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E3D5217D9
        for <linux-sgx@vger.kernel.org>; Mon, 17 Dec 2018 20:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545077430;
        bh=ryMIVu4Zmu6P2F/2xwOzzWnMPWMEZsy0oZCxTdFnGgo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Pul9NxsfSYWCzUMrJPWlDqkcu0iBR7zB/TIgLv1+syRoFZ6mgKwivHerywkSilv4L
         607wdVEikd9ZSWcxZtwKIw8B3YjUkleQy9458hcshgZ6ZliLQ1els8dgiJLq8Ssom1
         bz5QWcE1d6rNlVywyyY/ae9KL+fn9WCJcN/evzf8=
Received: by mail-wr1-f41.google.com with SMTP id 96so13631197wrb.2
        for <linux-sgx@vger.kernel.org>; Mon, 17 Dec 2018 12:10:30 -0800 (PST)
X-Gm-Message-State: AA+aEWaIrCye4WSLdxDnhMgHGPqsIOeVfMqLJFmHN6pNGiwpqaXYLGig
        zR6W/Lrt8xpdV+ATOmCZt086FmESc2TXuSLoeMBABA==
X-Google-Smtp-Source: AFSGD/VM3edS6O8zz+RsOBb4JTUkevr2P5McfhitYh1Xo92EGS8IuoMZPSy3Ik31ENeUguBXU5lOAviZXYHYa7n6Az8=
X-Received: by 2002:adf:e08c:: with SMTP id c12mr11214927wri.199.1545077428920;
 Mon, 17 Dec 2018 12:10:28 -0800 (PST)
MIME-Version: 1.0
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com> <7d5cde02-4649-546b-0f03-2d6414bb80b5@intel.com>
 <20181217180102.GA12560@linux.intel.com> <20181217183613.GD12491@linux.intel.com>
 <20181217184333.GA26920@linux.intel.com> <ccfb67a0-fd8d-82c8-8018-fd68e901f287@intel.com>
 <CALCETrX0W4dhFJBHEbDbKed_QZxmw6ZNMajfsoVgqGqhMB0nDg@mail.gmail.com>
 <beea8ad3-a607-5478-ad87-b8dd33e86146@intel.com> <20181217194913.GD29785@linux.intel.com>
 <16fdd37a-b9cc-1045-1497-2cfff6af176a@intel.com> <CALCETrUhVDxMAtpyn5ahsTFwhJkzWxKa5Ur8q4FuVaKLmSyYHQ@mail.gmail.com>
 <826f6a5a-fdf6-e7e5-d2d8-bcdc57c016fe@intel.com>
In-Reply-To: <826f6a5a-fdf6-e7e5-d2d8-bcdc57c016fe@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 17 Dec 2018 12:10:17 -0800
X-Gmail-Original-Message-ID: <CALCETrX_7g+GYj2hHvFjodPw_ryrVTQdF2M3p+KYNTBUOhg-8g@mail.gmail.com>
Message-ID: <CALCETrX_7g+GYj2hHvFjodPw_ryrVTQdF2M3p+KYNTBUOhg-8g@mail.gmail.com>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        shay.katz-zamir@intel.com,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 17, 2018 at 12:03 PM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 12/17/18 11:55 AM, Andy Lutomirski wrote:
> >> You're effectively rebuilding reverse-mapping infrastructure here.  It's
> >> a frequent thing for the core VM to need to go from 'struct page' back
> >> to the page tables mapping it.  For that we go (logically)
> >> page->{anon_vma,mapping}->vma->vm_mm->pagetable.
> > This is a bit outside my expertise here, but doesn't
> > unmap_mapping_range() do exactly what SGX wants?
>
> There's no 'struct page' for enclave memory as it stands.  That means no
> page cache, and that means there's no 'struct address_space *mapping' in
> the first place.
>
> Basically, the choice was made a long time ago to have SGX's memory
> management live outside the core VM.  I've waffled back and forth on it,
> but I do still think this is the right way to do it.

AFAICS a lack of struct page isn't a problem.  The core code seems to
understand that address_space objects might cover non-struct-page
memory.  Morally, enclave memory is a lot like hot-unpluggable PCI
space.
