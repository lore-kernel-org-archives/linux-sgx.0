Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAF72192F3
	for <linux-sgx@vger.kernel.org>; Fri, 25 Apr 2025 21:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745618313; cv=none; b=dvyvTh6b5Y82MtwokMdzCs0SkrlV67w++NFRjCijmqVul9kAl2Q97rW8vTCu9wE/o3v6V3bvAx/nz/SWzeCst096WIbrxKqoeVPQ3FQXNjrmiGR1wMUbdrH8hJQVKTNBRG9SDiVJZw9A/AXopHBLM/Sdm+pWXkv6qn7ymdEdL3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745618313; c=relaxed/simple;
	bh=nlrjxlQBn4QDkl4nD9eRz10BhKpa3Zy+kDdUe23cZhI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EE0bACxi3Is2jyG7wj/zMS7WKTi1P4Z41+Y49Z9+dVq3MhF+/2ywXRd9/V1M5YIvVNLbIL5GV9dexraULMRpW9npc/ysPgeqx7aIXs+ItdK+6NJpqvp8MFrMeBDL1uY0bTrPNzPdlBX3egVbWFiyRazXAB5XJuvYsopwzAW2me4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jau6+wPG; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jau6+wPG"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736b2a25d9fso1942085b3a.0
        for <linux-sgx@vger.kernel.org>; Fri, 25 Apr 2025 14:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745618311; x=1746223111; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OnjZAjlxaCS/Ix/Ff+GvicWfGPT6j7/1j45wJAOEfTQ=;
        b=Jau6+wPGT4SqRjiwE+SvV83RylhilF/2bKzx4vnQN5Iv2UGKvkVGCVMc8OyP1rYAaN
         uhYSl65ouAypxU5ac485LevEndumNKrc3Y23g1gx9mTCiCKBqFKHwhr8WjOgZj27eVcs
         AcFHgIteSvtIZ4X+4nroIppdDKeXEwA982ItKxm1eYGTCBWWfGD6lTmjI0lUAnYOiXUS
         anBNtBdgf31PTFv6QGIkGFvSaLB0o8A5QdoMgPps+y3inHD1dwy76Iuqw2XU3OkKNW6G
         IjvMp28xfQnosP0tWWogjaR3O5l+upOc8RXpbF2gItT9hqEzClE/0Ml2AM+qQk9+NsLt
         Ps4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745618311; x=1746223111;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OnjZAjlxaCS/Ix/Ff+GvicWfGPT6j7/1j45wJAOEfTQ=;
        b=RZZeOuzAiMocLVi/ZV4awd5guNIRCn/3dnjjH3j31aaXrdx9acx3HZve39ZO1bB078
         uDCuKwmVIXsR+ZfRl+z9H0+bIIBhCZ2V7lPSzfSYINh+Kv35/yvmuAOtf2K2gZ25rGK3
         axMhu20lIQ+WUxgVZS6R5qUGiJw1Rhj3G0Rj6MQ3VRyhXBLqI4UO14GViy6haduLje7Q
         RHTp30jfSNvMdkBmewvxjKYUsSzclUM9Kk1h3KAvOpjLql3GQqI8FF7CMEaKMMgoDBqX
         Ar/vTPrHaFPNXJ+7HlyFe5mYSmiX2uiEbPlahw/UTwb+i1MzpfR4RQ3gw+fsU4DmIQ8f
         QT2g==
X-Forwarded-Encrypted: i=1; AJvYcCXP2zp39hwkcrhSHt7QqsVKPa1HKk9wRjf3us/kfagHdpxEiREvusYP1BUx+yrIgMszxDVWRhW0hkY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp6RnB6waKJTwi63UPQvvCyrPCrSk5cZvxM4RQ6jYsjMAbm3Nw
	h+6W2Hp5VIBDP0h55FN13gDVEmWuw6CUEa6vDd/f3/8PKrQflfPH5e1OiZQQYHhQOWZ0HYLS8Sb
	bZg==
X-Google-Smtp-Source: AGHT+IHTe0CjQt3IK80UyV2xWXutllBPoyStfeBNWRtTh0faqqijRUQAJBPYR2ZInDA1PJzZPIWfkb5jzFk=
X-Received: from pfbfj39.prod.google.com ([2002:a05:6a00:3a27:b0:736:6fb6:7fc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4f95:b0:73e:2dcf:e44a
 with SMTP id d2e1a72fcca58-73fd896a1damr4826171b3a.16.1745618310833; Fri, 25
 Apr 2025 14:58:30 -0700 (PDT)
Date: Fri, 25 Apr 2025 14:58:29 -0700
In-Reply-To: <db1fd062-5a66-4942-82e2-c889dd645a7b@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aAo_2MPGOkOciNuM@google.com> <DM8PR11MB5750D373790399E324B98A18E7852@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aApgOqHvsYNd-yht@google.com> <DM8PR11MB5750AB0E790096AFF9AFD3AFE7842@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aAutUaQvgEliXPUs@google.com> <0d7d6b9a-e7bd-4225-8f08-05bd9473a894@intel.com>
 <aAviqeAdGn-w1GpK@google.com> <fbd2acdb-35dc-4e8c-9bd9-e84264f88648@intel.com>
 <aAv445Sr71NUJP1X@google.com> <db1fd062-5a66-4942-82e2-c889dd645a7b@intel.com>
Message-ID: <aAwFhaqQDLXoqbmv@google.com>
Subject: Re: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>, "jarkko@kernel.org" <jarkko@kernel.org>, 
	Kai Huang <kai.huang@intel.com>, 
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, Vincent Scarlata <vincent.r.scarlata@intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, Vishal Annapurve <vannapurve@google.com>, Chong Cai <chongc@google.com>, 
	Asit K Mallick <asit.k.mallick@intel.com>, Erdem Aktas <erdemaktas@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bondarn@google.com" <bondarn@google.com>, 
	"dionnaglaze@google.com" <dionnaglaze@google.com>, Scott Raynor <scott.raynor@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 25, 2025, Dave Hansen wrote:
> On 4/25/25 14:04, Sean Christopherson wrote:
> > Userspace is going to be waiting on ->release() no matter what.
> 
> Unless it isn't even involved and it happens automatically.

With my Google hat on: no thanks.

Customer:   Hey Google, why haven't you applied security update XYZ?
Support:    We have.
Customer:   The SVN in my attestation report says otherwise.
Support:    Let me check with engineering.
TDX team:   We applied the ucode update provided by platforms.  Platforms, what's up?
Platforms:  That's the right ucode patch.
TDX team:   Hmm, the kernel is supposed to update the SVN.  Let's bug the kernel team.
Me:         Have you guaranteed there are no active enclaves after the update?
TDX team:   Yep.
Me:         <tries to debug the problem, but it's in prod and only happens on
             some platforms>
Me:         Our theory is that enclaves haven't been fully destroyed when the
            hold is lifted.  Try adding a delay?  Maybe 1s?
TDX team:   That helped, but we still have intermittent failures.
Me:         How about 5 seconds?
TDX team:   Great, that worked!
Support:    Sorry for the delay, we're rolling out a fix, you should see the correct
            SVN shortly.
<time passes>
Customer:   Hey Google, my TDX VMs are stalled for 5 seconds during boot.
Support:    Let me check with engineering...


Is that likely to happen?  No.  Is a delay of multiple seconds likely?  Also no.
But it's not that far fetched.  And if something does go sideways, e.g. an EPC
page gets leaked, or enclave FD gets orphaned and left opened, etc., then I would
much, much prefer that the issue be visible to userspace.  Things going sideways
is inevitable; being able to take action when badness happens makes a world of
difference.

Coupled with adding latency to launching the 0=>1 enclave, just to handle something
that happens a few times per year, and I don't see any value in automatic updates.
Maybe it sounds nice on paper, but from my perspective, I see nothing but pain.
