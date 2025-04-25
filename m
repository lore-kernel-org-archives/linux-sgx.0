Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FA420E710
	for <linux-sgx@vger.kernel.org>; Fri, 25 Apr 2025 21:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745615079; cv=none; b=Si/fSmNNaGS+RQcpF/JRXehP/uY55Oz0pYfTvGURkEKzxt+X3HEBnxq1j4n1kSRhlZrgRtZObn0EqfX9nQLEzaV1l8adR7nhzYLwIBC+Ze2WPKAsW6SrxVNpy7OJBfhWUzhZtwCMyxlaQl3l5hHPiJPyN/9jVIXlOwdFyk1Rzmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745615079; c=relaxed/simple;
	bh=epG39JZkjG/ddR4llWAGnqrIO2moCEaRCU0iQ4RkT2U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g567zC6Lu96pHS7MWs0txXxMun9OyaEAAhnL3xvhLmRqrhDhkIZfvCiht7oL9Cwsit4KJKQIJJBGpnXcwh9HPuZEmT7/g5qWlQk+unoxKzuONhccFtN14Kykz/7TtR7Y5CnyYfUAdyeLcRKd+k89gSrQHVN6GaWH1Dl5zty3QSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nso7JQVw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nso7JQVw"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30364fc706fso2148805a91.3
        for <linux-sgx@vger.kernel.org>; Fri, 25 Apr 2025 14:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745615077; x=1746219877; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qRqh29BKlQXXngqfuV7TkfsfUqyvx8B5g8UhAF+NEFc=;
        b=nso7JQVwiQ4nUYWJyGgp5IupcaL1yS9T+YIBQe6FyXUv5tqSd5dA/6vPK6tf3cgUNu
         ym7JlqtANHja0Bn1d4hpqu60cc+GEvYgWSBYXZHWS5ujxUDfQwOlbDSLoL5IF0/qfbnb
         vgBLQdeSRgzA1tyLiDhVJvmZ0oQs63ULUS14ml6VDSdNFjW0MosEJwHy8A4DW5DqJPTC
         ZOzWUt0Il13Jqa14RhAsTzocH5OZoQhYH4HCfALTPiAVs1rco8lCDFu5yyIRvMkzjSe0
         TaStEDhQ0/QpPQbeR9Zw8InGwFrJLgZg2R3GeF/WRGn/Rd75hHaoSzOne/5fW3ElguvE
         Qdow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745615077; x=1746219877;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qRqh29BKlQXXngqfuV7TkfsfUqyvx8B5g8UhAF+NEFc=;
        b=kbKAXogKz7lNcHZU9vY76PkVgNcuE1y0hZIKsBIljYC6AI4bPQQmYqNndyBXUTx37Y
         BQtjzMHau+EE3mimf3SReGFohyTB/GJ8nFNdHnC9jfQPwaMeBksO3l/6dLZCkvAzvqE+
         wJz18Zs/8Pg5ceZzDtScGHY7jw+lyEeB2QKInrE8fls/LQ42qfsAZ8p9xKV0Rm8XWda3
         sxQm5pV4LJrnNFMdY2KwnYChVFCKOnzPIhTC8voWNsZMVUoOXAR8zEg7Gd9Lt2Dlc8rm
         1XJH+6srBkUc9ED6RnxcR2iMupYbawjcgZEFQZLPAeb/t5ERZ8YFcglvtiyhY+TEcmxi
         fOeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUllLMjRsBnfZwN7fkFeFsdtHutplu7sIuS2/fV2B0kirH2emI43RySUJNfvLjSlIBdpmjRMe9FXE4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJmUFWce0QFRbbFxUkKU2MeGAWm070kOrMecMdfiYB2gC+t13m
	PGWS0m/AwnosEWSnkl2Z5jD7B/IeLk4q5gew3LqUqiN0Ioj72DrATyqAidJjEOUXcL9SFEKql5W
	tZQ==
X-Google-Smtp-Source: AGHT+IE326Wh3qcKfJ1d21W9CKn1B0nxcqlcKKldPtg1TZutsfCecMsrD87Xb7co8Q1216t5oskIRF8czVc=
X-Received: from pjbqx5.prod.google.com ([2002:a17:90b:3e45:b0:2fa:1481:81f5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:254b:b0:305:5f25:fcf8
 with SMTP id 98e67ed59e1d1-309f8d8cd5bmr5286548a91.5.1745615077380; Fri, 25
 Apr 2025 14:04:37 -0700 (PDT)
Date: Fri, 25 Apr 2025 14:04:35 -0700
In-Reply-To: <fbd2acdb-35dc-4e8c-9bd9-e84264f88648@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aAefmNVRFc3me6QQ@google.com> <DM8PR11MB5750B37305B3B1FAE4F42D3AE7852@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aAo_2MPGOkOciNuM@google.com> <DM8PR11MB5750D373790399E324B98A18E7852@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aApgOqHvsYNd-yht@google.com> <DM8PR11MB5750AB0E790096AFF9AFD3AFE7842@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aAutUaQvgEliXPUs@google.com> <0d7d6b9a-e7bd-4225-8f08-05bd9473a894@intel.com>
 <aAviqeAdGn-w1GpK@google.com> <fbd2acdb-35dc-4e8c-9bd9-e84264f88648@intel.com>
Message-ID: <aAv445Sr71NUJP1X@google.com>
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
> On 4/25/25 12:29, Sean Christopherson wrote:
> > --- a/arch/x86/kernel/cpu/sgx/virt.c
> > +++ b/arch/x86/kernel/cpu/sgx/virt.c
> > @@ -255,6 +255,7 @@ static int sgx_vepc_release(struct inode *inode, struct file *file)
> >  	xa_destroy(&vepc->page_array);
> >  	kfree(vepc);
> >  
> > +	sgx_dec_usage_count();
> >  	return 0;
> >  }
> 
> ->release() is not close(). Userspace doesn't have control over when
> release() gets called, so it's a poor thing to say: "wait until all SGX
> struct files have been released, then do EUPDATESVN". At least that's
> what folks have always told me when I went poking around the VFS.
> 
> That alone would make this a non-starter.

And what frees all the EPC pages?  Hint: it's starts with an 'r'.

Userspace is going to be waiting on ->release() no matter what.  There's no getting
around that, all enclaves and virtual EPC instances must be fully destroyed to
ensure the EPC is empty.

At least with this approach, userspace can know that the EPC is "busy", whereas
with automatic updates, userspace has zero visibility.  The only breadcrumb it
would get is the SVN, which presumably can only be retrieved from within an encave.
But even if userspace can easily read the SVN, unless userspace has a priori
knowledge of the SVN it expects, userspace has no way of knowing if the SVN isn't
changing because no update was required, or if the SVN isn't changing because
the kernel can't find a window where there's no active EPC page.

Exposing -EBUSY to userspace gives it a variety of options.  E.g. retry N times,
with M delay, and then force a reboot if all else fails.

If we wanted to be more explicit, it would be trivial to add a getter, but IMO
that's completely unnecessary, as it's fully redundant with the errno from the
setter.

E.g.

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index e8fcf032e842..4dc95d59c11f 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -958,14 +958,26 @@ static int sgx_update_svn(const char *buffer, const struct kernel_param *kp)
        }
 }
 
+static int sgx_can_update_svn(char *buffer, const struct kernel_param *kp)
+{
+       if (!sgx_has_eupdatesvn)
+               return sysfs_emit(buffer, "unsupported\n");
+
+       if (atomic_read(&sgx_usage_count))
+               return sysfs_emit(buffer, "busy\n");
+
+       return sysfs_emit(buffer, "ready\n");
+}
+
 static const struct kernel_param_ops sgx_update_svn_ops = {
        .set = sgx_update_svn,
+       .get = sgx_can_update_svn,
 };
 
 #undef MODULE_PARAM_PREFIX
 #define MODULE_PARAM_PREFIX "sgx."
-device_param_cb(update_svn, &sgx_update_svn_ops, NULL, 0200);
-__MODULE_PARM_TYPE(update_svn, "bool");
+device_param_cb(update_svn, &sgx_update_svn_ops, NULL, 0644);
+__MODULE_PARM_TYPE(update_svn, "int");
 
 static int __init sgx_init(void)
 {

